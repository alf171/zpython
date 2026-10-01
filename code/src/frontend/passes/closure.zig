const std = @import("std");
const HashMap = std.AutoHashMap;
const Operand = @import("common").alloc.Operand;
const TypedOperand = @import("common").alloc.TypedOperand;
const Function = @import("common").function.Function;
const Param = @import("common").function.Param;
const Program = @import("common").program.Program;
const Instruction = @import("common").mir.Instruction;
const TypeInfo = @import("common").types.TypeInfo;
const ValueRef = @import("common").ir.ValueRef;

/// rewrite closure closure into regular functions
pub fn rewrite(program: *Program, alloc: std.mem.Allocator) !void {
    var incoming_targets: std.StringHashMap(HashMap(usize, []const u8)) = .init(alloc);
    defer {
        var functions = incoming_targets.valueIterator();
        while (functions.next()) |params| {
            var labels = params.valueIterator();
            while (labels.next()) |label| {
                alloc.free(label.*);
            }
            params.deinit();
        }
        incoming_targets.deinit();
    }
    var known_targets: HashMap(Operand, []const u8) = .init(alloc);
    defer {
        var it = known_targets.valueIterator();
        while (it.next()) |label| {
            alloc.free(label.*);
        }
        known_targets.deinit();
    }
    try rewriteFunction(&program.main, program, &incoming_targets, &known_targets, alloc);
    for (program.functions.items) |*function| {
        try rewriteFunction(function, program, &incoming_targets, &known_targets, alloc);
    }
}

fn rewriteFunction(
    function: *Function,
    program: *const Program,
    incoming_targets: *std.StringHashMap(HashMap(usize, []const u8)),
    known_targets: *HashMap(Operand, []const u8),
    alloc: std.mem.Allocator,
) !void {
    for (function.blocks.items) |*block| {
        var new_instructions = std.ArrayList(Instruction).empty;
        errdefer new_instructions.deinit(alloc);

        for (block.instructions.items) |*instruction| {
            switch (instruction.*) {
                .function_call => |fc| {
                    const callee_label = switch (fc.callee) {
                        .direct => |label| label,
                        .indirect => {
                            try new_instructions.append(alloc, instruction.*);
                            continue;
                        },
                    };
                    for (fc.args, 0..) |arg, i| {
                        if (arg.type != .callable) continue;

                        const target = known_targets.get(arg.operand) orelse {
                            return error.CantFindFunction;
                        };

                        const entry = try incoming_targets.getOrPut(callee_label);
                        if (!entry.found_existing) {
                            entry.value_ptr.* = .init(alloc);
                        }

                        std.debug.assert(!entry.value_ptr.contains(i));
                        try entry.value_ptr.put(i, try alloc.dupe(u8, target));
                    }
                    try new_instructions.append(alloc, instruction.*);
                },
                .function_param => |param| {
                    if (incoming_targets.get(param.label)) |params| {
                        if (params.get(param.index)) |target| {
                            try known_targets.put(param.dst.operand, try alloc.dupe(u8, target));
                        }
                    }
                    try new_instructions.append(alloc, instruction.*);
                },
                .function_ref => |fr| {
                    try known_targets.put(fr.dst.operand, try alloc.dupe(u8, fr.label));
                    try new_instructions.append(alloc, instruction.*);
                },
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
                    try known_targets.put(cc.dst.operand, try alloc.dupe(u8, cc.label));
                    if (cc.captures.len == 0) {
                        try new_instructions.append(alloc, .{ .function_ref = .{
                            .dst = try cc.dst.clone(alloc),
                            .label = try alloc.dupe(u8, cc.label),
                        } });
                        instruction.deinit(alloc);
                        continue;
                    }
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
                    const closure_type = try closure_fn.type.toString(alloc);
                    defer alloc.free(closure_type);
                    // std.debug.print("closure type for {s}: {s}\n", .{ cc.label, closure_type });
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
                    if (known_targets.get(cc.callee.operand)) |label| {
                        const target = program.findFunction(label) orelse {
                            return error.CantFindFunction;
                        };

                        if (target.captures.items.len == 0) {
                            const args = try alloc.alloc(TypedOperand, cc.args.len);
                            for (cc.args, 0..) |arg, i| {
                                args[i] = try arg.clone(alloc);
                            }

                            try new_instructions.append(alloc, .{ .function_call = .{
                                .dst = if (cc.dst) |dst| try dst.clone(alloc) else null,
                                .callee = .{ .direct = try alloc.dupe(u8, target.label) },
                                .args = args,
                            } });
                            instruction.deinit(alloc);
                            continue;
                        }
                    }
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
