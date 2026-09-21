const std = @import("std");
const ArrayList = std.array_list.Managed;

const Function = @import("common").function.Function;
const Program = @import("common").program.Program;
const Instruction = @import("common").mir.Instruction;
const ColorGraph = @import("color.zig").ColoredGraph;
const SeenValuePtr = @import("common").ir.SeenValuePtr;

/// apply colors onto Operands
pub fn run(program: *Program, colors: *const ColorGraph, abi: anytype, alloc: std.mem.Allocator) !void {
    try runFunction(&program.main, colors, abi, alloc);
    for (program.functions.items) |*function| {
        try runFunction(function, colors, abi, alloc);
    }
}

pub fn runFunction(function: *Function, colors: *const ColorGraph, abi: anytype, alloc: std.mem.Allocator) !void {
    for (function.blocks.items) |block| {
        for (block.instructions.items) |*instruction| {
            const define = instruction.getDefinePtrs();
            if (define) |def| {
                try applyColor(def, colors, abi);
            }
            var uses = try instruction.getUsePtrs(alloc);
            defer uses.deinit(alloc);
            for (uses.items) |use| {
                try applyColor(use, colors, abi);
            }
        }
    }
}

fn applyColor(value: SeenValuePtr, colors: *const ColorGraph, abi: anytype) !void {
    switch (value) {
        .local => {},
        .top => |top| {
            const operand = top.operand;
            switch (operand) {
                .temp => {
                    const node = colors.nodes.get(operand) orelse {
                        return;
                    };
                    const color = node.register orelse {
                        return error.MissingColor;
                    };
                    top.operand = .{
                        .reg = try abi.regForColor(color, node.reg_class),
                    };
                },
                .reg, .mem => {},
                .unknown => return error.InvalidOperand,
            }
        },
    }
}
