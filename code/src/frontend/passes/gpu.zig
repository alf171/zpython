const std = @import("std");
const ArrayList = std.ArrayList;
const HashMap = std.AutoHashMap;
const TypedOperand = @import("common").alloc.TypedOperand;
const Function = @import("common").function.Function;
const Param = @import("common").function.Param;
const Program = @import("common").program.Program;
const Instruction = @import("common").mir.Instruction;
const TypeInfo = @import("common").types.TypeInfo;
const ValueRef = @import("common").ir.ValueRef;
const GpuListField = @import("common").gpu.GpuListField;

const GpuArgField = struct {
    offset: usize,
    layout: GpuArgLayout,
};

pub const GpuArgLayout = union(enum) {
    scalar: struct {
        size: usize,
    },
    list: struct {
        element_size: usize,
    },
    instance: struct {
        size: usize,
        fields: []GpuArgField,
    },

    pub fn deinit(self: @This(), alloc: std.mem.Allocator) void {
        switch (self) {
            .instance => |instance| {
                for (instance.fields) |field| {
                    field.layout.deinit(alloc);
                }
                alloc.free(instance.fields);
            },
            else => {},
        }
    }
};

/// sets default params
pub fn rewrite(program: *Program, alloc: std.mem.Allocator) !void {
    try rewriteFunction(program, &program.main, alloc);
    for (program.functions.items) |*function| {
        try rewriteFunction(program, function, alloc);
    }
}

fn rewriteFunction(
    program: *const Program,
    function: *Function,
    alloc: std.mem.Allocator,
) !void {
    for (function.blocks.items) |*block| {
        var new_instructions: ArrayList(Instruction) = .empty;
        errdefer new_instructions.deinit(alloc);

        for (block.instructions.items) |*instruction| {
            switch (instruction.*) {
                .gpu_launch => |gl| {
                    // emit: gpu_launch(arg_slots, arg_count, work_items, kernel_name)
                    var new_args: ArrayList(TypedOperand) = .empty;
                    errdefer {
                        for (new_args.items) |*arg| {
                            arg.deinit(alloc);
                        }
                        new_args.deinit(alloc);
                    }
                    {
                        var elements: ArrayList(ValueRef) = .empty;
                        errdefer {
                            for (elements.items) |elem| {
                                elem.deinit(alloc);
                            }
                            elements.deinit(alloc);
                        }
                        var element_types: ArrayList(TypeInfo) = .empty;
                        errdefer {
                            for (element_types.items) |elem| {
                                elem.deinit(alloc);
                            }
                            element_types.deinit(alloc);
                        }
                        for (gl.args) |arg| {
                            const arg_layout = try buildGpuArgLayout(arg.type, program, alloc);
                            defer arg_layout.deinit(alloc);
                            switch (arg_layout) {
                                // emit: [value, 0]
                                .scalar => {
                                    try elements.append(alloc, .{ .top = try arg.clone(alloc) });
                                    try elements.append(alloc, .{ .constant = .{ .i64 = 0 } });
                                    try elements.append(alloc, .{ .constant = .{ .i64 = 0 } });
                                    try element_types.append(alloc, .i64);
                                    try element_types.append(alloc, .i64);
                                    try element_types.append(alloc, .i64);
                                },
                                // [value, <byte_count>]
                                .list => |list| {
                                    try elements.append(alloc, .{ .top = try arg.clone(alloc) });
                                    try element_types.append(alloc, try arg.type.clone(alloc));
                                    // const byte_count = 8 + elem_size * elem_count;
                                    // emit instructions since elem_count is only known at runtime
                                    const elem_size_value: TypedOperand = .{
                                        .operand = function.nextTemp(),
                                        .type = .i64,
                                    };
                                    try new_instructions.append(alloc, .{ .lir = .{ .move = .{
                                        .dst = elem_size_value,
                                        .src = .{ .constant = .{ .i64 = @intCast(list.element_size) } },
                                    } } });
                                    const elem_count: TypedOperand = .{
                                        .operand = function.nextTemp(),
                                        .type = .i64,
                                    };
                                    try new_instructions.append(alloc, .{ .len = .{
                                        .dst = elem_count,
                                        .value = try arg.clone(alloc),
                                    } });
                                    const data_bytes: TypedOperand = .{
                                        .operand = function.nextTemp(),
                                        .type = .i64,
                                    };
                                    try new_instructions.append(alloc, .{ .lir = .{ .binop = .{
                                        .dst = data_bytes,
                                        .lhs = try elem_size_value.clone(alloc),
                                        .op = .mul,
                                        .rhs = try elem_count.clone(alloc),
                                    } } });
                                    const byte_count: TypedOperand = .{
                                        .operand = function.nextTemp(),
                                        .type = .i64,
                                    };
                                    const eight: TypedOperand = .{
                                        .operand = function.nextTemp(),
                                        .type = .i64,
                                    };
                                    try new_instructions.append(alloc, .{ .lir = .{ .move = .{
                                        .dst = eight,
                                        .src = .{ .constant = .{ .i64 = 8 } },
                                    } } });
                                    try new_instructions.append(alloc, .{ .lir = .{ .binop = .{
                                        .dst = byte_count,
                                        .lhs = try data_bytes.clone(alloc),
                                        .op = .add,
                                        .rhs = eight,
                                    } } });
                                    try elements.append(alloc, .{ .top = try byte_count.clone(alloc) });
                                    try element_types.append(alloc, .i64);
                                    try elements.append(alloc, .{ .constant = .{ .i64 = 0 } });
                                    try element_types.append(alloc, .i64);
                                },
                                .instance => |instance| {
                                    var list_elements: ArrayList(ValueRef) = .empty;
                                    var list_types: ArrayList(TypeInfo) = .empty;
                                    var list_field_count: usize = 0;
                                    defer list_elements.deinit(alloc);
                                    defer list_types.deinit(alloc);
                                    for (instance.fields) |field| {
                                        switch (field.layout) {
                                            .scalar => {},
                                            .list => |list| {
                                                list_field_count += 1;
                                                try list_elements.append(alloc, .{ .constant = .{
                                                    .i64 = @intCast(field.offset),
                                                } });
                                                try list_elements.append(alloc, .{ .constant = .{
                                                    .i64 = @intCast(list.element_size),
                                                } });
                                                try element_types.append(alloc, .i64);
                                                try element_types.append(alloc, .i64);
                                            },
                                            else => |e| {
                                                std.debug.print("cant handle {s}\n", .{@tagName(e)});
                                                return error.NotImpl;
                                            },
                                        }
                                    }
                                    // FIXME: CLEAN THIS CODE UP
                                    const list_fields_dst: TypedOperand = .{
                                        .operand = function.nextTemp(),
                                        .type = .{ .tuple = .{
                                            .elements = try list_types.toOwnedSlice(alloc),
                                        } },
                                    };
                                    try new_instructions.append(alloc, .{
                                        .tuple_literal = .{
                                            .dst = list_fields_dst,
                                            .elements = try list_elements.toOwnedSlice(alloc),
                                        },
                                    });

                                    const layout_types = try alloc.alloc(TypeInfo, 3);
                                    layout_types[0] = .i64;
                                    layout_types[1] = .i64;
                                    layout_types[2] = try list_fields_dst.type.clone(alloc);
                                    const layout_dst: TypedOperand = .{
                                        .operand = function.nextTemp(),
                                        .type = .{ .tuple = .{ .elements = layout_types } },
                                    };
                                    const layout_elements = try alloc.alloc(ValueRef, 3);
                                    layout_elements[0] = .{
                                        .constant = .{ .i64 = @intCast(instance.size) },
                                    };
                                    layout_elements[1] = .{
                                        .constant = .{
                                            .i64 = @intCast(list_field_count),
                                        },
                                    };
                                    layout_elements[2] = .{
                                        .top = try list_fields_dst.clone(alloc),
                                    };
                                    try new_instructions.append(alloc, .{
                                        .tuple_literal = .{
                                            .dst = layout_dst,
                                            .elements = layout_elements,
                                        },
                                    });
                                    // FIXME: CLEAN THIS CODE UP
                                    try elements.append(alloc, .{
                                        .top = try arg.clone(alloc),
                                    });
                                    try elements.append(alloc, .{
                                        .constant = .{ .i64 = @intCast(instance.size) },
                                    });
                                    try elements.append(alloc, .{
                                        .top = try layout_dst.clone(alloc),
                                    });
                                    try element_types.append(alloc, try arg.type.clone(alloc));
                                    try element_types.append(alloc, .i64);
                                    try element_types.append(alloc, try layout_dst.type.clone(alloc));
                                },
                            }
                        }
                        const dst: TypedOperand = .{
                            .operand = function.nextTemp(),
                            .type = .{ .tuple = .{
                                .elements = try element_types.toOwnedSlice(alloc),
                            } },
                        };
                        try new_instructions.append(alloc, .{
                            .tuple_literal = .{
                                .dst = dst,
                                .elements = try elements.toOwnedSlice(alloc),
                            },
                        });
                        try new_args.append(alloc, try dst.clone(alloc));
                    }
                    const arg_count: TypedOperand = .{
                        .operand = function.nextTemp(),
                        .type = .i64,
                    };
                    try new_instructions.append(alloc, .{ .lir = .{ .move = .{
                        .dst = arg_count,
                        .src = .{ .constant = .{ .i64 = @intCast(gl.args.len) } },
                    } } });
                    try new_args.append(alloc, arg_count);
                    try new_args.append(alloc, try gl.work_items.clone(alloc));
                    const kernel_elements = try alloc.alloc(ValueRef, gl.kernel.len + 1);
                    const kernel_type = try alloc.alloc(TypeInfo, gl.kernel.len + 1);
                    for (gl.kernel, 0..) |ch, i| {
                        kernel_elements[i] = .{ .constant = .{ .char = ch } };
                        kernel_type[i] = .char;
                    }
                    kernel_elements[gl.kernel.len] = .{ .constant = .{ .char = 0 } };
                    kernel_type[gl.kernel.len] = .char;

                    const kernel_name: TypedOperand = .{
                        .operand = function.nextTemp(),
                        .type = .{ .tuple = .{ .elements = kernel_type } },
                    };
                    try new_args.append(alloc, kernel_name);
                    try new_instructions.append(alloc, .{
                        .tuple_literal = .{
                            .dst = try kernel_name.clone(alloc),
                            .elements = kernel_elements,
                        },
                    });
                    try new_instructions.append(alloc, .{
                        .function_call = .{
                            .dst = null,
                            .args = try new_args.toOwnedSlice(alloc),
                            .callee = .{ .direct = try alloc.dupe(u8, "gpu_launch") },
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

fn buildGpuArgLayout(type_info: TypeInfo, program: *const Program, alloc: std.mem.Allocator) !GpuArgLayout {
    return switch (type_info) {
        .i64, .i32, .callable => .{ .scalar = .{ .size = try type_info.sizeOfType() } },
        .list => |list| .{ .list = .{ .element_size = try list.element.sizeOfType() } },
        .instance => |instance| {
            for (program.classes.items) |class| {
                if (class.id == instance.class_id) {
                    var fields = try alloc.alloc(GpuArgField, class.fields.items.len);
                    var initialized: usize = 0;
                    errdefer {
                        for (fields[0..initialized]) |field| {
                            field.layout.deinit(alloc);
                        }
                        alloc.free(fields);
                    }
                    for (class.fields.items, 0..) |field, i| {
                        const field_type = try class.resolveFieldType(&field, instance, alloc);
                        defer field_type.deinit(alloc);
                        fields[i] = .{
                            .offset = try class.resolveOffset(instance, i, program, alloc),
                            .layout = try buildGpuArgLayout(field_type, program, alloc),
                        };
                        initialized += 1;
                    }
                    return .{ .instance = .{
                        .size = try class.resolveOffset(instance, class.fields.items.len, program, alloc),
                        .fields = fields,
                    } };
                }
            }
            return error.CantFindClass;
        },
        else => |e| {
            std.debug.print("cant handle passing {s} to the gpu\n", .{@tagName(e)});
            return error.NotImpl;
        },
    };
}
