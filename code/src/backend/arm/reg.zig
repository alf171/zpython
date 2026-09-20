const std = @import("std");
const common = @import("common");
const ValueRef = common.ir.ValueRef;
const CpuAbi = @import("../cpu_abi.zig").CpuAbi;
const PhysicalReg = @import("common").ir.PhysicalReg;
const RegisterType = @import("common").register.RegisterType;

pub const ArmRegister = enum {
    // general purpose registers
    x0,
    x1,
    x2,
    x3,
    x4,
    x5,
    x6,
    x7,
    x8,
    x9,
    x10,
    x11,
    x12,
    x13,
    x14,
    x15,
    x16,
    x17,
    x18,
    x19,
    x20,
    x21,
    x22,
    x23,
    x24,
    x25,
    x26,
    x27,
    x28,
    x29,
    x30,
    sp,
    // fp/simd registers
    d0,
    d1,
    d2,
    d3,
    d4,
    d5,
    d6,
    d7,
    d8,
    d9,
    d10,
    d11,
    d12,
    d13,
    d14,
    d15,
    d16,
    d17,
    d18,
    d19,
    d20,
    d21,
    d22,
    d23,
    d24,
    d25,
    d26,
    d27,
    d28,
    d29,
    d30,
    d31,

    pub fn registerType(self: @This()) RegisterType {
        return switch (self) {
            .x0, .x1, .x2, .x3, .x4, .x5, .x6, .x7, .x8, .x9, .x10, .x11, .x12, .x13, .x14, .x15, .x16, .x17, .x18, .x19, .x20, .x21, .x22, .x23, .x24, .x25, .x26, .x27, .x28, .x29, .x30, .sp => .gp,
            .d0, .d1, .d2, .d3, .d4, .d5, .d6, .d7, .d8, .d9, .d10, .d11, .d12, .d13, .d14, .d15, .d16, .d17, .d18, .d19, .d20, .d21, .d22, .d23, .d24, .d25, .d26, .d27, .d28, .d29, .d30, .d31 => .f,
        };
    }

    pub fn physical(self: @This(), index: u8, width: u8) PhysicalReg {
        return .{
            .id = @intFromEnum(self),
            .index = index,
            .type = self.registerType(),
            .width = width,
        };
    }
};

// reserve two regs for scratch purposes
const gp_scratch_reg = ArmRegister.x16.physical(0, 8);
const gp_scratch_reg_2 = ArmRegister.x17.physical(0, 8);

/// function param registers
const gp_function_param_regs = [_]PhysicalReg{
    ArmRegister.x0.physical(0, 8),
    ArmRegister.x1.physical(1, 8),
    ArmRegister.x2.physical(2, 8),
    ArmRegister.x3.physical(3, 8),
    ArmRegister.x4.physical(4, 8),
    ArmRegister.x5.physical(5, 8),
    ArmRegister.x6.physical(6, 8),
    ArmRegister.x7.physical(7, 8),
};

/// callee save registers
const gp_callee_save_regs = [_]PhysicalReg{
    ArmRegister.x19.physical(16, 8),
    ArmRegister.x20.physical(17, 8),
    ArmRegister.x21.physical(18, 8),
    ArmRegister.x22.physical(19, 8),
    ArmRegister.x23.physical(20, 8),
    ArmRegister.x24.physical(21, 8),
    ArmRegister.x25.physical(22, 8),
    ArmRegister.x26.physical(23, 8),
    ArmRegister.x27.physical(24, 8),
    ArmRegister.x28.physical(25, 8),
};

/// caller save registers
/// in order to allow using x0-x7, we need to write percoloring code so that we dont have a collision
const gp_caller_save_regs = [_]PhysicalReg{
    ArmRegister.x8.physical(8, 8),
    ArmRegister.x9.physical(9, 8),
    ArmRegister.x10.physical(10, 8),
    ArmRegister.x11.physical(11, 8),
    ArmRegister.x12.physical(12, 8),
    ArmRegister.x13.physical(13, 8),
    ArmRegister.x14.physical(14, 8),
    ArmRegister.x15.physical(15, 8),
};

pub const fp_scratch_reg = ArmRegister.d16.physical(0, 8);

/// function param registers
const fp_function_param_regs = [_]PhysicalReg{
    ArmRegister.d0.physical(0, 8),
    ArmRegister.d1.physical(1, 8),
    ArmRegister.d2.physical(2, 8),
    ArmRegister.d3.physical(3, 8),
    ArmRegister.d4.physical(4, 8),
    ArmRegister.d5.physical(5, 8),
    ArmRegister.d6.physical(6, 8),
    ArmRegister.d7.physical(7, 8),
};

/// callee save registers
const fp_callee_save_regs = [_]PhysicalReg{
    ArmRegister.d19.physical(16, 8),
    ArmRegister.d20.physical(17, 8),
    ArmRegister.d21.physical(18, 8),
    ArmRegister.d22.physical(19, 8),
    ArmRegister.d23.physical(20, 8),
    ArmRegister.d24.physical(21, 8),
    ArmRegister.d25.physical(22, 8),
    ArmRegister.d26.physical(23, 8),
    ArmRegister.d27.physical(24, 8),
    ArmRegister.d28.physical(25, 8),
};

/// caller save registers
/// in order to allow using d0-d7, we need to write percoloring code so that we dont have a collision
const fp_caller_save_regs = [_]PhysicalReg{
    ArmRegister.d8.physical(8, 8),
    ArmRegister.d9.physical(9, 8),
    ArmRegister.d10.physical(10, 8),
    ArmRegister.d11.physical(11, 8),
    ArmRegister.d12.physical(12, 8),
    ArmRegister.d13.physical(13, 8),
    ArmRegister.d14.physical(14, 8),
    ArmRegister.d15.physical(15, 8),
};

pub fn getRegisterName(register: PhysicalReg) []const u8 {
    const arm_register: ArmRegister = @enumFromInt(register.id);
    return @tagName(arm_register);
}

pub const ArmAbi = CpuAbi.init(
    &gp_function_param_regs,
    &gp_caller_save_regs,
    &gp_callee_save_regs,
    0,
    &.{ gp_scratch_reg, gp_scratch_reg_2 },
    &fp_function_param_regs,
    &fp_caller_save_regs,
    &fp_callee_save_regs,
    0,
    &.{fp_scratch_reg},
    getRegisterName,
);
