const std = @import("std");
const ArrayList = std.array_list.Managed;
const c = @import("python.zig").c;
const PyObject = c.PyObject;

const IrBuilder = @import("ir_builder.zig").IrBuilder;
const LocalId = @import("common").ir.LocalId;
const CmpOp = @import("common").ir.CmpOp;
const TypedOperand = @import("common").alloc.TypedOperand;
const PhiInput = @import("common").mir.PhiInput;
const Instruction = @import("common").mir.Instruction;
const LocalValues = @import("ir_builder.zig").LocalValues;
const LoopPhi = @import("common").mir.LoopPhi;
const walkExpr = @import("walk.zig").walkExpr;
const walkStmtList = @import("walk.zig").walkStmtList;

pub const LoopCondition = union(enum) {
    expr: *PyObject,
    compare: struct {
        local: LocalId,
        cmp: CmpOp,
        rhs_local: LocalId,
    },
    operand_compare: struct {
        carry_index: usize,
        cmp: CmpOp,
        rhs: TypedOperand,
    },
};

pub const LoopBody = union(enum) {
    stmt_list: *PyObject,
    for_loop: ForLoopBody,
};

pub const ForLoopBody = struct {
    stmt_list: *PyObject,
    condition_var_name: []const u8,
    iterator: TypedOperand,
    iterator_local: ?LocalId,
};

// used for phi book keeping within our callback
pub const LoopCarry = struct {
    initial: TypedOperand,
    current: TypedOperand,
    next: ?TypedOperand,
    inputs: []PhiInput,
};

pub fn walkLoop(
    ir_builder: *IrBuilder,
    condition: LoopCondition,
    body: LoopBody,
    carries: []LoopCarry,
    bodyCallback: *const fn (LoopBody, []LoopCarry, *IrBuilder, std.mem.Allocator) anyerror!void,
    orelse_: ?*PyObject,
    alloc: std.mem.Allocator,
) !void {
    var before_values = try ir_builder.currentScope().local_values.clone(alloc);
    defer before_values.deinit(alloc);

    const condition_block = try ir_builder.newBlock(alloc);
    const body_block = try ir_builder.newBlock(alloc);
    const exit_block = try ir_builder.newBlock(alloc);

    const entry_block = ir_builder.current_block;
    try ir_builder.emit(Instruction{ .lir = .{ .jump = .{
        .target = condition_block,
    } } }, alloc);
    try ir_builder.addSuccessor(entry_block, condition_block, alloc);

    ir_builder.setCurrentBlock(condition_block);
    ir_builder.currentScope().local_values.clear(alloc);
    var loop_values: LocalValues = .init(alloc);
    defer loop_values.deinit(alloc);
    var loop_phis: ArrayList(LoopPhi) = .init(alloc);
    defer loop_phis.deinit();

    var before_it = before_values.map.iterator();
    // shadowed values causing phis
    while (before_it.next()) |entry| {
        const local = entry.key_ptr.*;
        const before_val = entry.value_ptr.*;

        var inputs = try alloc.alloc(PhiInput, 2);
        inputs[0] = .{
            .pred = entry_block,
            .value = try before_val.clone(alloc),
        };
        inputs[1] = undefined;

        const dst: TypedOperand = .{
            .operand = ir_builder.nextTemp(),
            .type = try before_val.type.clone(alloc),
        };
        try ir_builder.emit(.{ .phi = .{
            .dst = dst,
            .inputs = inputs,
        } }, alloc);
        try ir_builder.currentScope().putLocalValues(local, try dst.clone(alloc), alloc);
        try loop_values.map.put(local, try dst.clone(alloc));
        try loop_phis.append(.{
            .local = local,
            .phi_inputs = inputs,
            .dst = dst,
        });
    }

    // callee defined phis
    for (carries) |*carry| {
        var inputs = try alloc.alloc(PhiInput, 2);
        inputs[0] = .{
            .pred = entry_block,
            .value = try carry.initial.clone(alloc),
        };
        inputs[1] = undefined;
        const dst = TypedOperand{
            .operand = ir_builder.nextTemp(),
            .type = try carry.initial.type.clone(alloc),
        };
        try ir_builder.emit(Instruction{ .phi = .{
            .dst = dst,
            .inputs = inputs,
        } }, alloc);

        carry.current = dst;
        carry.inputs = inputs;
    }

    const condition_expr = switch (condition) {
        .expr => |cond| try walkExpr(cond, ir_builder, null, alloc),
        .compare => |comp| blk: {
            const dst: TypedOperand = .{
                .operand = ir_builder.nextTemp(),
                .type = .bool,
            };
            const lhs = ir_builder.currentScope().local_values.map.get(comp.local) orelse return error.LocalNotFound;
            const rhs = ir_builder.currentScope().local_values.map.get(comp.rhs_local) orelse return error.LocalNotFound;
            try ir_builder.emit(.{ .lir = .{ .binop = .{
                .dst = dst,
                .lhs = lhs,
                .op = .{ .cmp = comp.cmp },
                .rhs = rhs,
            } } }, alloc);
            break :blk dst;
        },
        .operand_compare => |comp| blk: {
            const dst: TypedOperand = .{
                .operand = ir_builder.nextTemp(),
                .type = .bool,
            };
            const lhs = carries[comp.carry_index].current;
            try ir_builder.emit(.{ .lir = .{ .binop = .{
                .dst = dst,
                .lhs = lhs,
                .op = .{ .cmp = comp.cmp },
                .rhs = comp.rhs,
            } } }, alloc);
            break :blk dst;
        },
    };

    try ir_builder.emit(.{ .lir = .{
        .branch = .{
            .condition = condition_expr,
            .then_block = body_block,
            .else_block = exit_block,
        },
    } }, alloc);
    try ir_builder.addSuccessor(condition_block, body_block, alloc);
    try ir_builder.addSuccessor(condition_block, exit_block, alloc);

    // body block
    ir_builder.setCurrentBlock(body_block);
    // naively restore since we dont support walrus
    try ir_builder.currentScope().restoreLocalValues(&loop_values, alloc);

    {
        try ir_builder.loop_stack.append(alloc, .{
            .continue_target = condition_block,
            .break_target = exit_block,
        });
        defer _ = ir_builder.loop_stack.pop();
        // crux
        try bodyCallback(body, carries, ir_builder, alloc);
    }

    const backedge_block = ir_builder.current_block;
    var body_values = try ir_builder.currentScope().local_values.clone(alloc);
    defer body_values.deinit(alloc);
    for (loop_phis.items) |loop_phi| {
        const value = body_values.map.get(loop_phi.local) orelse loop_phi.dst;
        loop_phi.phi_inputs[1] = .{
            .pred = backedge_block,
            .value = try value.clone(alloc),
        };
    }

    for (carries) |carry| {
        const value = carry.next orelse return error.CarryNotSet;
        carry.inputs[1] = .{
            .pred = backedge_block,
            .value = try value.clone(alloc),
        };
    }

    try ir_builder.emit(Instruction{ .lir = .{
        .jump = .{ .target = condition_block },
    } }, alloc);
    try ir_builder.addSuccessor(backedge_block, condition_block, alloc);

    // exit block
    ir_builder.setCurrentBlock(exit_block);
    // naively restore since we dont support walrus
    try ir_builder.currentScope().restoreLocalValues(&loop_values, alloc);
    if (orelse_) |orelse_val| {
        try walkStmtList(orelse_val, ir_builder, alloc);
    }
}
