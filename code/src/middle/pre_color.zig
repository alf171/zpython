const std = @import("std");
const CpuAbi = @import("backend").CpuAbi;
const IrProgram = @import("common").program.Program;
const Copy = @import("common").mir.Copy;
const Function = @import("common").function.Function;
const TypedOperand = @import("common").alloc.TypedOperand;
const Operand = @import("common").alloc.Operand;
const Instruction = @import("common").mir.Instruction;
const IGraph = @import("igraph.zig").IGraph;
const PhysicalReg = @import("common").ir.PhysicalReg;

pub fn apply(ir_program: *IrProgram, abi: CpuAbi, alloc: std.mem.Allocator) !void {
    try applyFunction(&ir_program.main, abi, alloc);
    for (ir_program.functions.items) |*function| {
        // only color cpu abi for now
        if (function.kind == .gpu_kernel)
            continue;
        try applyFunction(function, abi, alloc);
    }
}

pub fn applyFunction(function: *Function, abi: CpuAbi, alloc: std.mem.Allocator) !void {
    for (function.blocks.items) |*block| {
        var new_instructions = std.ArrayList(Instruction).empty;
        errdefer new_instructions.deinit(alloc);

        for (block.instructions.items) |*instruction| {
            switch (instruction.*) {
                .function_param => |fp| {
                    const reg = try abi.paramRegFor(fp.index, fp.dst.type.toRegisterType(function.kind));
                    try new_instructions.append(alloc, .{ .lir = .{ .move = .{
                        .dst = try fp.dst.clone(alloc),
                        .src = .{ .top = .{
                            .operand = .{
                                .reg = reg,
                            },
                            .type = try fp.dst.type.clone(alloc),
                        } },
                    } } });
                    instruction.deinit(alloc);
                },
                .function_return => |fr| {
                    if (fr.value) |src_op| {
                        const reg: TypedOperand = .{
                            .operand = .{ .reg = abi.getFunctionReturn(function.return_type) },
                            .type = try function.return_type.clone(alloc),
                        };
                        try new_instructions.append(alloc, .{ .lir = .{ .move = .{
                            .dst = reg,
                            .src = .{
                                .top = try src_op.clone(alloc),
                            },
                        } } });
                        // emits branch with proper coloring
                        try new_instructions.append(alloc, .{
                            .function_return = .{ .value = try reg.clone(alloc) },
                        });
                    } else {
                        // emits branch
                        try new_instructions.append(alloc, instruction.*);
                    }
                    instruction.deinit(alloc);
                },
                .function_call => |fc| {
                    var copies = try alloc.alloc(Copy, fc.args.len);
                    errdefer alloc.free(copies);
                    // place new args to ensure proper coloring / interference
                    var args = try alloc.alloc(TypedOperand, fc.args.len);
                    errdefer alloc.free(args);
                    for (fc.args, 0..) |arg, i| {
                        const reg: Operand = .{ .reg = try abi.paramRegFor(i, arg.type.toRegisterType(function.kind)) };
                        copies[i] = .{
                            .dst = .{
                                .operand = reg,
                                .type = try arg.type.clone(alloc),
                            },
                            .src = arg.operand,
                        };
                        args[i] = .{
                            .operand = reg,
                            .type = try arg.type.clone(alloc),
                        };
                    }
                    try new_instructions.append(alloc, .{ .parallel_copy = .{
                        .copies = copies,
                    } });
                    // jumps to function
                    try new_instructions.append(alloc, .{ .function_call = .{
                        .dst = null,
                        .callee = try fc.callee.clone(alloc),
                        .args = args,
                    } });
                    if (fc.dst) |dst| {
                        try new_instructions.append(alloc, .{ .lir = .{
                            .move = .{
                                .dst = try dst.clone(alloc),
                                .src = .{ .top = .{
                                    .operand = .{ .reg = abi.getFunctionReturn(dst.type) },
                                    .type = try dst.type.clone(alloc),
                                } },
                            },
                        } });
                    }
                    instruction.deinit(alloc);
                },
                else => try new_instructions.append(alloc, instruction.*),
            }
        }
        block.instructions.deinit(alloc);
        block.instructions = new_instructions;
    }
}
