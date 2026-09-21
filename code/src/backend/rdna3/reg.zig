pub const GpuAbi = @import("../gpu_abi.zig").GpuAbi;
const RegisterType = @import("common").register.RegisterType;
const PhysicalReg = @import("common").ir.PhysicalReg;

fn registerRange(comptime reg_type: RegisterType, comptime first_id: u8, comptime count: usize) [count]PhysicalReg {
    var registers: [count]PhysicalReg = undefined;
    for (0..count) |color| {
        registers[color] = .{
            .id = first_id + @as(u8, @intCast(color)),
            .index = @intCast(color),
            .type = reg_type,
            .width = 4,
        };
    }
    return registers;
}

// in order to support 64 bit data types, reserve to registers per color
const sgpr_allocatable_regs = registerRange(.sgpr, 4, 13);
// v0 contains workgroup info
const vgpr_allocatable_regs = registerRange(.vgpr, 1, 30);
// scratch regs
const sgpr_scratch_regs = registerRange(.sgpr, 17, 1);
const vgpr_scratch_regs = registerRange(.vgpr, 31, 2);

pub const Rdna3Abi = GpuAbi.init(&sgpr_allocatable_regs, &vgpr_allocatable_regs, &sgpr_scratch_regs, &vgpr_scratch_regs);
