const std = @import("std");
const HashMap = std.AutoHashMap;
const TypedOperand = @import("common").alloc.TypedOperand;
const Function = @import("common").function.Function;
const Param = @import("common").function.Param;
const Program = @import("common").program.Program;
const Instruction = @import("common").mir.Instruction;
const TypeInfo = @import("common").types.TypeInfo;
const ValueRef = @import("common").ir.ValueRef;

/// rewrite closure closure into regular functions
pub fn rewrite(program: *Program, alloc: std.mem.Allocator) !void {
    try rewriteFunction(&program.main, alloc);
    for (program.functions.items) |*function| {
        try rewriteFunction(function, alloc);
    }
}

fn rewriteFunction(
    function: *Function,
    alloc: std.mem.Allocator,
) !void {
    for (function.blocks.items) |*block| {
        var new_instructions = std.ArrayList(Instruction).empty;
        errdefer new_instructions.deinit(alloc);

        for (block.instructions.items) |*instruction| {
            switch (instruction.*) {
                // dst = load_offset env, (index+1)*8
                // we'll hardcode 8 for now to avoid generics
                .load_capture => |lc| {
                    try new_instructions.append(alloc, .{ .lir = .{ .load_offset = .{
                        .dst = try lc.dst.clone(alloc),
                        .src = try lc.env.clone(alloc),
                        .offset = .{ .constant = .{ .i64 = @intCast((lc.index + 1) * 8) } },
                    } } });
                    instruction.deinit(alloc);
                },
                // [closure fn] [capture 0] [capture 1] ...
                .closure_create => |cc| {
                    const size_temp = function.nextTemp();
                    try new_instructions.append(alloc, .{ .lir = .{ .move = .{
                        .dst = .{ .operand = size_temp, .type = .i64 },
                        .src = .{ .constant = .{ .i64 = @intCast((cc.captures.len + 1) * 8) } },
                    } } });
                    const args = try alloc.dupe(TypedOperand, &.{
                        .{ .operand = size_temp, .type = .i64 },
                    });
                    try new_instructions.append(alloc, .{ .function_call = .{
                        .dst = try cc.dst.clone(alloc),
                        .callee = .{
                            .direct = try alloc.dupe(u8, "arena_malloc"),
                        },
                        .args = args,
                    } });
                    const closure_fn: TypedOperand = .{
                        .operand = function.nextTemp(),
                        .type = try cc.dst.type.clone(alloc),
                    };
                    try new_instructions.append(alloc, .{ .function_ref = .{
                        .dst = closure_fn,
                        .label = try alloc.dupe(u8, cc.label),
                    } });
                    try new_instructions.append(alloc, .{ .lir = .{ .store_offset = .{
                        .dst = try cc.dst.clone(alloc),
                        .src = try closure_fn.clone(alloc),
                        .offset = .{ .constant = .{ .i64 = 0 } },
                    } } });
                    for (cc.captures, 0..) |capture, i| {
                        try new_instructions.append(alloc, .{ .lir = .{ .store_offset = .{
                            .dst = try cc.dst.clone(alloc),
                            .src = try capture.clone(alloc),
                            .offset = .{ .constant = .{ .i64 = @intCast((i + 1) * 8) } },
                        } } });
                    }
                    instruction.deinit(alloc);
                },
                // covnert into function_call
                .closure_call => |cc| {
                    const fn_ptr: TypedOperand = .{
                        .operand = function.nextTemp(),
                        .type = try cc.callee.type.clone(alloc),
                    };
                    try new_instructions.append(alloc, .{ .lir = .{ .load_offset = .{
                        .dst = try fn_ptr.clone(alloc),
                        .src = try cc.callee.clone(alloc),
                        .offset = .{ .constant = .{ .i64 = 0 } },
                    } } });
                    const args = try alloc.alloc(TypedOperand, cc.args.len + 1);
                    args[0] = try cc.callee.clone(alloc);
                    for (cc.args, 0..) |arg, i| {
                        args[i + 1] = try arg.clone(alloc);
                    }
                    try new_instructions.append(alloc, .{
                        .function_call = .{
                            .dst = if (cc.dst) |dst| try dst.clone(alloc) else null,
                            .callee = .{ .indirect = fn_ptr },
                            .args = args,
                        },
                    });
                    instruction.deinit(alloc);
                },
                else => try new_instructions.append(alloc, instruction.*),
            }
        }
        block.instructions.deinit(alloc);
        block.instructions = new_instructions;
    }
}
