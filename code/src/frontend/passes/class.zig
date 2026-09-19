const std = @import("std");
const ArrayList = std.ArrayList;
const Program = @import("common").program.Program;
const Function = @import("common").function.Function;
const Instruction = @import("common").mir.Instruction;
const TypedOperand = @import("common").alloc.TypedOperand;

pub fn lowerCalls(program: *Program, alloc: std.mem.Allocator) !void {
    try lowerCall(program, &program.main, alloc);
    for (program.functions.items) |*function| {
        try lowerCall(program, function, alloc);
    }
}

fn lowerCall(program: *Program, function: *Function, alloc: std.mem.Allocator) !void {
    for (function.blocks.items) |*block| {
        var new_instructions: ArrayList(Instruction) = .empty;
        errdefer new_instructions.deinit(alloc);
        for (block.instructions.items) |*instruction| {
            switch (instruction.*) {
                // instance <- Class(*args)
                // :becomes:
                // instance <- class_alloc()
                // class.__init__(instance, *args)
                .class_init => |ci| {
                    const class = &program.classes.items[ci.class_id];
                    const method = class.findMethod("__init__") orelse {
                        return error.CantFindInit;
                    };
                    // after generics, this will become malloc
                    // we dont know size until after generics
                    try new_instructions.append(alloc, .{ .class_alloc = .{
                        .dst = try ci.dst.clone(alloc),
                    } });
                    // call __init__
                    var new_function_args: ArrayList(TypedOperand) = .empty;
                    try new_function_args.append(alloc, try ci.dst.clone(alloc));
                    for (ci.args) |arg| {
                        try new_function_args.append(
                            alloc,
                            try arg.clone(alloc),
                        );
                    }
                    try new_instructions.append(alloc, .{ .function_call = .{
                        .dst = null,
                        .callee = .{
                            .direct = try alloc.dupe(u8, method.function_label),
                        },
                        .args = try new_function_args.toOwnedSlice(alloc),
                    } });
                    instruction.deinit(alloc);
                },
                // dst <- src[index]
                // :becomes:
                // call __getitem__(self, attr)
                .subscript => |s| {
                    if (s.src.type != .instance) {
                        try new_instructions.append(alloc, instruction.*);
                        continue;
                    }

                    const class = &program.classes.items[s.src.type.instance.class_id];

                    const method = class.findMethod("__getitem__") orelse {
                        return error.CantFindBuiltin;
                    };

                    var arguments = try alloc.alloc(TypedOperand, 2);
                    errdefer {
                        for (arguments) |*arg| {
                            arg.deinit(alloc);
                        }
                    }
                    arguments[0] = try s.src.clone(alloc);
                    arguments[1] = try s.index.clone(alloc);

                    try new_instructions.append(alloc, .{
                        .function_call = .{
                            .dst = try s.dst.clone(alloc),
                            .callee = .{
                                .direct = try alloc.dupe(u8, method.function_label),
                            },
                            .args = arguments,
                        },
                    });
                    instruction.deinit(alloc);
                },
                .subscript_store => |ss| {
                    if (ss.target.type != .instance) {
                        try new_instructions.append(alloc, instruction.*);
                        continue;
                    }

                    const class = &program.classes.items[ss.target.type.instance.class_id];

                    const method = class.findMethod("__setitem__") orelse {
                        return error.CantFindBuiltin;
                    };

                    var arguments = try alloc.alloc(TypedOperand, 3);
                    errdefer {
                        for (arguments) |*arg| {
                            arg.deinit(alloc);
                        }
                    }
                    arguments[0] = try ss.target.clone(alloc);
                    arguments[1] = try ss.index.clone(alloc);
                    arguments[2] = switch (ss.src) {
                        .top => |top| try top.clone(alloc),
                        .constant => |c| blk: {
                            const tmp: TypedOperand = .{
                                .operand = function.nextTemp(),
                                .type = c.toType(),
                            };
                            try new_instructions.append(alloc, .{ .lir = .{ .move = .{
                                .dst = tmp,
                                .src = .{ .constant = c },
                            } } });
                            break :blk tmp;
                        },
                    };

                    try new_instructions.append(alloc, .{
                        .function_call = .{
                            .dst = null,
                            .callee = .{
                                .direct = try alloc.dupe(u8, method.function_label),
                            },
                            .args = arguments,
                        },
                    });
                    instruction.deinit(alloc);
                },
                .lir => |lir| switch (lir) {
                    .binop => |bop| {
                        const instance = switch (bop.lhs.type) {
                            .instance => |id| id,
                            else => {
                                try new_instructions.append(alloc, instruction.*);
                                continue;
                            },
                        };
                        const class = &program.classes.items[instance.class_id];
                        const method_name = try bop.op.toClassBuiltin();
                        const method = class.findMethod(method_name) orelse {
                            return error.CantFindBuiltin;
                        };
                        var arguments: ArrayList(TypedOperand) = .empty;
                        errdefer {
                            for (arguments.items) |*arg| {
                                arg.type.deinit(alloc);
                            }
                            arguments.deinit(alloc);
                        }

                        // replace + with __add__(self, other)
                        try arguments.append(alloc, try bop.lhs.clone(alloc));
                        try arguments.append(alloc, try bop.rhs.clone(alloc));
                        try new_instructions.append(alloc, .{
                            .function_call = .{
                                .dst = try bop.dst.clone(alloc),
                                .callee = .{
                                    .direct = try alloc.dupe(u8, method.function_label),
                                },
                                .args = try arguments.toOwnedSlice(alloc),
                            },
                        });

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

pub fn lowerStorage(program: *Program, alloc: std.mem.Allocator) !void {
    try lowerStorageFunction(program, &program.main, alloc);
    for (program.functions.items) |*function| {
        try lowerStorageFunction(program, function, alloc);
    }
}

fn lowerStorageFunction(program: *Program, function: *Function, alloc: std.mem.Allocator) !void {
    for (function.blocks.items) |*block| {
        var new_instructions: ArrayList(Instruction) = .empty;
        errdefer new_instructions.deinit(alloc);
        for (block.instructions.items) |*instruction| {
            switch (instruction.*) {
                // dst <- class_alloc()
                // :becomes:
                // dst <- malloc(dst.size)
                .class_alloc => |ca| {
                    std.debug.assert(ca.dst.type == .instance);
                    const instance = ca.dst.type.instance;
                    const class = &program.classes.items[instance.class_id];
                    // malloc
                    const size_temp = function.nextTemp();
                    const size = try class.resolveOffset(instance, class.fields.items.len, program, alloc);
                    try new_instructions.append(alloc, .{ .lir = .{ .move = .{
                        .dst = .{ .operand = size_temp, .type = .i64 },
                        .src = .{ .constant = .{ .i64 = @intCast(size) } },
                    } } });
                    const args = try alloc.dupe(TypedOperand, &.{
                        .{ .operand = size_temp, .type = .i64 },
                    });
                    try new_instructions.append(alloc, .{ .function_call = .{
                        .dst = try ca.dst.clone(alloc),
                        .callee = .{
                            .direct = try alloc.dupe(u8, "arena_malloc"),
                        },
                        .args = args,
                    } });
                    instruction.deinit(alloc);
                },
                // self.attr = attr
                // :becomes:
                // store_at_addr(self + attr_offset, attr)
                .field_store => |fs| {
                    std.debug.assert(fs.instance.type == .instance);
                    const instance = fs.instance.type.instance;
                    const class = &program.classes.items[instance.class_id];
                    const offset = try class.resolveOffset(instance, fs.field_index, program, alloc);
                    try new_instructions.append(alloc, .{ .lir = .{
                        .store_offset = .{
                            .dst = try fs.instance.clone(alloc),
                            .offset = .{ .constant = .{ .i64 = @intCast(offset) } },
                            .src = try fs.src.clone(alloc),
                        },
                    } });
                    instruction.deinit(alloc);
                },
                // self.field
                .field_load => |fl| {
                    std.debug.assert(fl.instance.type == .instance);
                    const instance = fl.instance.type.instance;
                    const class = &program.classes.items[instance.class_id];
                    const offset = try class.resolveOffset(instance, fl.field_index, program, alloc);
                    try new_instructions.append(alloc, .{ .lir = .{
                        .load_offset = .{
                            .dst = try fl.dst.clone(alloc),
                            .offset = .{
                                .constant = .{ .i64 = @intCast(offset) },
                            },
                            .src = try fl.instance.clone(alloc),
                        },
                    } });
                    instruction.deinit(alloc);
                },
                else => try new_instructions.append(alloc, instruction.*),
            }
        }
        block.instructions.deinit(alloc);
        block.instructions = new_instructions;
    }
}
