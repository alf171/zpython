const std = @import("std");
const Program = @import("common").program.Program;
const Instruction = @import("common").mir.Instruction;
const TypedOperand = @import("common").alloc.TypedOperand;

/// append a return to main
pub fn insertReturn(program: *Program, alloc: std.mem.Allocator) !void {
    for (program.main.blocks.items) |*block| {
        if (block.successors.items.len != 0) continue;
        if (block.instructions.getLastOrNull()) |last| {
            if (last == .lir and last.lir == .function_return) continue;
        }
        const status: TypedOperand = .{
            .operand = program.main.nextTemp(),
            .type = .i32,
        };
        try block.instructions.append(alloc, .{ .lir = .{ .move = .{
            .dst = status,
            .src = .{ .constant = .{ .i32 = 0 } },
        } } });
        try block.instructions.append(alloc, .{ .lir = .{ .function_return = .{
            .value = try status.clone(alloc),
        } } });
    }
}

/// call _arena_free at the end of our main
pub fn injectCleanup(program: *Program, alloc: std.mem.Allocator) !void {
    for (program.main.blocks.items) |*block| {
        if (block.successors.items.len != 0) continue;
        var index = block.instructions.items.len;
        if (block.instructions.getLastOrNull()) |last| {
            // last item is return so insert free right before
            if (last == .lir and last.lir == .function_return) index -= 1;
        }
        try block.instructions.insert(alloc, index, .{ .lir = .{ .function_call = .{
            .dst = null,
            .callee = .{ .direct = try alloc.dupe(u8, "arena_free") },
            .args = try alloc.alloc(TypedOperand, 0),
        } } });
    }
}
