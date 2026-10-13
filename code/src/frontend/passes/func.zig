const std = @import("std");
const HashMap = std.AutoHashMap;
const TypedOperand = @import("common").alloc.TypedOperand;
const Function = @import("common").function.Function;
const Param = @import("common").function.Param;
const Program = @import("common").program.Program;
const Instruction = @import("common").mir.Instruction;
const TypeInfo = @import("common").types.TypeInfo;
const ValueRef = @import("common").ir.ValueRef;

/// sets default params
pub fn rewrite(program: *Program, alloc: std.mem.Allocator) !void {
    var function_params: std.StringHashMap([]Param) = .init(alloc);
    defer function_params.deinit();
    for (program.functions.items) |*function| {
        try function_params.put(function.label, function.params);
    }

    try rewriteFunction(program, &program.main, &function_params, alloc);
    for (program.functions.items) |*function| {
        try rewriteFunction(program, function, &function_params, alloc);
    }
}

fn rewriteFunction(
    program: *const Program,
    function: *Function,
    function_params: *std.StringHashMap([]Param),
    alloc: std.mem.Allocator,
) !void {
    for (function.blocks.items) |*block| {
        var new_instructions: std.ArrayList(Instruction) = .empty;
        errdefer new_instructions.deinit(alloc);

        for (block.instructions.items) |*instruction| {
            switch (instruction.*) {
                // rewrite default paramater
                .function_call => |fc| {
                    const fun_name = switch (fc.callee) {
                        .direct => |name| name,
                        .indirect => {
                            try new_instructions.append(alloc, instruction.*);
                            continue;
                        },
                    };

                    const params = function_params.get(fun_name) orelse {
                        try new_instructions.append(alloc, instruction.*);
                        continue;
                    };
                    // no missing args
                    if (fc.args.len >= params.len) {
                        try new_instructions.append(alloc, instruction.*);
                        continue;
                    }
                    var new_args = try alloc.alloc(TypedOperand, params.len);
                    errdefer alloc.free(new_args);

                    // fill new_args
                    for (fc.args, 0..) |arg, i| {
                        new_args[i] = try arg.clone(alloc);
                    }
                    for (params[fc.args.len..], fc.args.len..) |param, i| {
                        const default = param.default orelse {
                            return error.ExpectedDefault;
                        };

                        const default_arg: TypedOperand = .{
                            .operand = function.nextTemp(),
                            .type = try default.toType().clone(alloc),
                        };

                        switch (default) {
                            .immediate => |value| {
                                try new_instructions.append(alloc, .{ .lir = .{ .move = .{
                                    .dst = try default_arg.clone(alloc),
                                    .src = .{ .constant = value },
                                } } });
                            },
                            .composite => |comp| {
                                const elements = try alloc.dupe(ValueRef, comp.elements);
                                errdefer alloc.free(elements);

                                try new_instructions.append(alloc, .{ .array_literal = .{
                                    .dst = try default_arg.clone(alloc),
                                    .elements = elements,
                                } });
                            },
                        }
                        // FIXME: this layer shouldnt need to work so hard to create a string
                        if (default == .composite and param.type == .instance and std.mem.eql(u8, program.classes.items[param.type.instance.class_id].name, "str")) {
                            const class = program.classes.items[param.type.instance.class_id];
                            const string: TypedOperand = .{
                                .operand = function.nextTemp(),
                                .type = .{
                                    .instance = .{
                                        .class_id = class.id,
                                        .args = try alloc.alloc(TypeInfo, 0),
                                    },
                                },
                            };

                            const args = try alloc.alloc(TypedOperand, 1);
                            args[0] = try default_arg.clone(alloc);

                            try new_instructions.append(alloc, .{
                                .class_init = .{
                                    .dst = string,
                                    .class_id = class.id,
                                    .args = args,
                                },
                            });
                            default_arg.deinit(alloc);
                            new_args[i] = try string.clone(alloc);
                        } else {
                            new_args[i] = default_arg;
                        }
                    }

                    try new_instructions.append(alloc, .{ .function_call = .{
                        .dst = if (fc.dst) |dst| try dst.clone(alloc) else null,
                        .args = new_args,
                        .callee = try fc.callee.clone(alloc),
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
