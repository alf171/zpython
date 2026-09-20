const std = @import("std");
const Function = @import("common").function.Function;
const Program = @import("common").program.Program;
const Operand = @import("common").alloc.Operand;
const RegisterType = @import("common").register.RegisterType;
const RegisterClass = @import("common").register.RegisterClass;
const RegisterClasses = @import("common").register.RegisterClasses;

/// going to select RegisterType in its own pass via a Map<Op, RegType> result
pub fn classify(program: Program, alloc: std.mem.Allocator) !RegisterClasses {
    var res: RegisterClasses = .init(alloc);
    try classifyFunction(program.main, &res);
    for (program.functions.items) |function| {
        try classifyFunction(function, &res);
    }
    return res;
}

fn classifyFunction(
    function: Function,
    classes: *RegisterClasses,
) !void {
    for (function.blocks.items) |block| {
        for (block.instructions.items) |instruction| {
            const define = instruction.getDefines() orelse continue;

            const value = switch (define) {
                .top => |top| top,
                .local => continue,
            };

            const register_class: RegisterClass = switch (function.kind) {
                .host => .{
                    .type = value.type.toRegisterType(.host),
                    .count = 1,
                },
                .gpu_kernel => switch (instruction) {
                    .function_param => .{
                        .type = .sgpr,
                        .count = @intCast((try value.type.sizeOfType() + 3) / 4),
                    },
                    else => .{
                        .type = .vgpr,
                        .count = @intCast((try value.type.sizeOfType() + 3) / 4),
                    },
                },
            };
            try classes.put(value.operand, register_class);
        }
    }
}
