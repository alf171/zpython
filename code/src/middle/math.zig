const std = @import("std");
const ArrayList = std.ArrayList;

const Function = @import("common").function.Function;
const Instruction = @import("common").mir.Instruction;
const Program = @import("common").program.Program;
const TypedOperand = @import("common").alloc.TypedOperand;

/// replaces ops with libm def on cpu
pub fn rewrite(program: *Program, alloc: std.mem.Allocator) !void {
    try runFunction(&program.main, alloc);
    for (program.functions.items) |*function| {
        if (function.kind != .host) continue;
        try runFunction(function, alloc);
    }
}

pub fn runFunction(function: *Function, alloc: std.mem.Allocator) !void {
    for (function.blocks.items) |*block| {
        var new_instructions: ArrayList(Instruction) = .empty;
        errdefer new_instructions.deinit(alloc);
        for (block.instructions.items) |*instruction| {
            switch (instruction.*) {
                .instrinsic_call => |ic| {
                    const t = if (ic.dst) |d| d.type else null;
                    const uop_symbol = try ic.op.libSymbol(t);
                    if (uop_symbol == null) {
                        return error.NotImpl;
                    }
                    const args = try alloc.alloc(TypedOperand, ic.args.len);
                    for (ic.args, 0..) |arg, i| {
                        args[i] = try arg.clone(alloc);
                    }
                    try new_instructions.append(alloc, .{ .function_call = .{
                        .dst = if (ic.dst) |d| try d.clone(alloc) else null,
                        .callee = .{ .direct = try alloc.dupe(u8, uop_symbol.?) },
                        .args = args,
                    } });
                    instruction.deinit(alloc);
                },
                .lir => |lir| switch (lir) {
                    .unaryop => |uop| {
                        if (uop.op != .exp2) {
                            try new_instructions.append(alloc, instruction.*);
                            continue;
                        }
                        const symbol: []const u8 = switch (uop.dst.type) {
                            .f64 => "exp2",
                            .f32 => "exp2f",
                            else => unreachable,
                        };

                        try new_instructions.append(alloc, .{ .function_call = .{
                            .dst = try uop.dst.clone(alloc),
                            .callee = .{ .direct = try alloc.dupe(u8, symbol) },
                            .args = try alloc.dupe(TypedOperand, &.{
                                try uop.src.clone(alloc),
                            }),
                        } });
                        instruction.deinit(alloc);
                    },
                    else => try new_instructions.append(alloc, instruction.*),
                },
                else => try new_instructions.append(alloc, instruction.*),
            }
        }
        block.instructions.deinit(alloc);
        block.instructions = new_instructions;
    }
}
