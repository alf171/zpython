const std = @import("std");
const ArrayList = std.ArrayList;
const HashMap = std.AutoHashMap;

const Operand = @import("common").alloc.Operand;
const Function = @import("common").ir.Function;
const ConstValue = @import("common").ir.ConstValue;
const Program = @import("common").program.Program;
const Instruction = @import("common").mir.Instruction;
const LirInstruction = @import("common").lir.Instruction;
const Binop = @FieldType(LirInstruction, "binop");

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

        var copyMap: HashMap(Operand, ConstValue) = .init(alloc);
        defer copyMap.deinit();

        for (block.instructions.items) |*instruction| {
            switch (instruction.*) {
                .lir => |lir| switch (lir) {
                    .move => |mov| {
                        switch (mov.src) {
                            .constant => |c| try copyMap.put(mov.dst.operand, c),
                            .top => {},
                        }
                        try new_instructions.append(alloc, instruction.*);
                    },
                    .binop => |bop| {
                        if (rewriteIntoMove(bop, &copyMap)) |simplification| {
                            switch (simplification) {
                                .lhs => {
                                    try new_instructions.append(alloc, .{ .lir = .{ .move = .{
                                        .dst = bop.dst,
                                        .src = .{ .top = bop.lhs },
                                    } } });
                                },
                                .rhs => {
                                    try new_instructions.append(alloc, .{ .lir = .{ .move = .{
                                        .dst = bop.dst,
                                        .src = .{ .top = bop.rhs },
                                    } } });
                                },
                                .constant => |value| {
                                    try new_instructions.append(alloc, .{ .lir = .{ .move = .{
                                        .dst = bop.dst,
                                        .src = .{ .constant = value },
                                    } } });
                                },
                            }
                        } else {
                            try new_instructions.append(alloc, instruction.*);
                        }
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

const SimplificationValue = union(enum) {
    lhs,
    rhs,
    constant: ConstValue,
};

/// return an Operand iff there is a valid rewrite
fn rewriteIntoMove(bop: Binop, copyMap: *const HashMap(Operand, ConstValue)) ?SimplificationValue {
    const lhs = copyMap.get(bop.lhs.operand);
    const rhs = copyMap.get(bop.rhs.operand);
    switch (bop.op) {
        .add => {
            if (rhs) |value| {
                if (value.isZero()) return .lhs;
            }
            if (lhs) |value| {
                if (value.isZero()) return .rhs;
            }
        },
        .sub => {
            if (rhs) |value| {
                if (value.isZero()) return .lhs;
            }
        },
        .mul => {
            if (rhs) |value| {
                if (value.isZero()) return .{ .constant = value };
                if (value.isOne()) return .lhs;
            }
            if (lhs) |value| {
                if (value.isZero()) return .{ .constant = value };
                if (value.isOne()) return .rhs;
            }
        },
        .div => {
            if (rhs) |value| {
                if (value.isOne()) return .lhs;
            }
        },
        .lshift, .rshift => {
            if (rhs) |value| {
                if (value.isZero()) return .lhs;
            }
        },
        else => return null,
    }
    return null;
}
