const std = @import("std");
const HashMap = std.AutoHashMap;
const TypedOperand = @import("common").alloc.TypedOperand;
const Function = @import("common").function.Function;
const Param = @import("common").function.Param;
const Program = @import("common").program.Program;
const Instruction = @import("common").mir.Instruction;
const TypeInfo = @import("common").types.TypeInfo;
const ValueRef = @import("common").ir.ValueRef;

/// support hashing instances and other types.
/// other types cant be in `walk.zig` because of generics.
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
        var new_instructions = std.ArrayList(Instruction).empty;
        errdefer new_instructions.deinit(alloc);

        for (block.instructions.items) |*instruction| {
            switch (instruction.*) {
                .hash => |h| {
                    switch (h.src.type) {
                        .instance => |instance| {
                            const class = &program.classes.items[instance.class_id].kind.record;
                            const method = class.findMethod("__hash__") orelse {
                                return error.CantFindHashFunction;
                            };
                            const f = program.findFunction(method.function_label) orelse {
                                return error.CantFindFunc;
                            };

                            const fargs = try alloc.alloc(TypedOperand, 1);
                            fargs[0] = try h.src.clone(alloc);

                            try new_instructions.append(alloc, .{ .function_call = .{
                                .dst = try h.dst.clone(alloc),
                                .callee = .{ .direct = try alloc.dupe(u8, f.label) },
                                .args = fargs,
                            } });
                            instruction.deinit(alloc);
                        },
                        else => |e| {
                            std.debug.print("cant handle {s}\n", .{@tagName(e)});
                            return error.NotImpl;
                        },
                    }
                },
                else => try new_instructions.append(alloc, instruction.*),
            }
        }
        block.instructions.deinit(alloc);
        block.instructions = new_instructions;
    }
}
