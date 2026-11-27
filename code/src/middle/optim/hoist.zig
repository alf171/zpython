const std = @import("std");
const ArrayList = std.ArrayList;
const HashMap = std.AutoHashMap;

const Block = @import("common").ir.BasicBlock;
const Function = @import("common").function.Function;
const Program = @import("common").program.Program;
const AllocProgram = @import("common").alloc.AllocProgram;
const Operand = @import("common").alloc.Operand;
const RegisterOperands = @import("common").alloc.RegisterOperands;
const LocalId = @import("common").ir.LocalId;
const Instruction = @import("common").mir.Instruction;
const SeenValue = @import("common").ir.SeenValue;

/// run loop invariant code motion
pub fn run(program: *Program, alloc: std.mem.Allocator) !void {
    try runFunction(&program.main, alloc);
    for (program.functions.items) |*function| {
        try runFunction(function, alloc);
    }
}

// compute dominators?
fn runFunction(function: *Function, alloc: std.mem.Allocator) !void {
    var defined_in_loop: HashMap(Operand, void) = .init(alloc);
    defer defined_in_loop.deinit();
    for (function.blocks.items) |*block| {
        // header -> block1 -> (block2/block3) -/-> block1
        if (block.successors.items.len != 1) {
            continue;
        }
        const block1 = &function.blocks.items[block.successors.items[0]];
        if (block1.successors.items.len != 2) {
            continue;
        }
        const block2 = &function.blocks.items[block1.successors.items[0]];
        const block3 = &function.blocks.items[block1.successors.items[1]];
        // keep track of back_block, body_block
        const block2_back = block2.successors.items.len == 1 and block2.successors.items[0] == block1.id;
        const block3_back = block3.successors.items.len == 1 and block3.successors.items[0] == block1.id;
        // need to alternate
        if (block2_back == block3_back) continue;
        const body_block = if (block2_back) block2 else block3;
        if (body_block.id == block.id) continue;

        // defined_in_loop = def(header) \union def(body)
        for (block1.instructions.items) |instruction| {
            if (instruction.getDefines()) |def| {
                switch (def) {
                    .top => |top| try defined_in_loop.put(top.operand, {}),
                    .local => {},
                }
            }
        }
        for (body_block.instructions.items) |instruction| {
            if (instruction.getDefines()) |def| {
                switch (def) {
                    .top => |top| try defined_in_loop.put(top.operand, {}),
                    .local => {},
                }
            }
        }

        // fold load_offset
        var i: usize = 0;
        while (i < body_block.instructions.items.len) {
            const instruction = body_block.instructions.items[i];
            const dst: ?Operand = switch (instruction) {
                .lir => |lir| switch (lir) {
                    .load_offset => |lo| if (lo.offset == .constant and !defined_in_loop.contains(lo.src.operand)) lo.dst.operand else null,
                    .binop => |bop| blk: {
                        if (bop.op == .bop and (bop.op.bop == .add or bop.op.bop == .mul) and !defined_in_loop.contains(bop.lhs.operand) and !defined_in_loop.contains(bop.rhs.operand)) {
                            break :blk bop.dst.operand;
                        }
                        break :blk null;
                    },
                    else => null,
                },
                else => null,
            };
            if (dst) |operand| {
                // std.debug.print("HOIST CHANCE IN {s}\n", .{function.name});
                const jump_index = block.instructions.items.len - 1;
                try block.instructions.ensureUnusedCapacity(alloc, 1);
                const moved = body_block.instructions.orderedRemove(i);
                block.instructions.insertAssumeCapacity(jump_index, moved);
                _ = defined_in_loop.remove(operand);
                continue;
            }
            i += 1;
        }
        defined_in_loop.clearRetainingCapacity();
    }
}
