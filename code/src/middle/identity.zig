const std = @import("std");
const ArrayList = std.ArrayList;

const Function = @import("common").function.Function;
const Instruction = @import("common").mir.Instruction;
const Program = @import("common").program.Program;

/// remove self moves
pub fn run(program: *Program, alloc: std.mem.Allocator) !void {
    try runFunction(&program.main, alloc);
    for (program.functions.items) |*function| {
        try runFunction(function, alloc);
    }
}

pub fn runFunction(function: *Function, alloc: std.mem.Allocator) !void {
    for (function.blocks.items) |*block| {
        var new_instructions: ArrayList(Instruction) = .empty;
        errdefer new_instructions.deinit(alloc);
        for (block.instructions.items) |*instruction| {
            switch (instruction.*) {
                .lir => |lir| switch (lir) {
                    .move => |mov| switch (mov.src) {
                        .top => |top| {
                            if (mov.dst.equal(top)) {
                                instruction.deinit(alloc);
                                continue;
                            }
                            try new_instructions.append(alloc, instruction.*);
                        },
                        .constant => try new_instructions.append(alloc, instruction.*),
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
