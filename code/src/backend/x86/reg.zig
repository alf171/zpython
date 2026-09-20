const std = @import("std");
const common = @import("common");
const ValueRef = common.ir.ValueRef;
const Abi = @import("../cpu_abi.zig").CpuAbi;
const PhysicalReg = @import("common").ir.PhysicalReg;
const RegisterType = @import("common").register.RegisterType;

pub const X86Register = enum(u8) {
    rax,
    rbx,
    rcx,
    rdx,
    rsi,
    rdi,
    r8,
    r9,
    r10,
    r11,
    r12,
    r13,
    r14,
    r15,
    xmm0,
    xmm1,
    xmm2,
    xmm3,
    xmm4,
    xmm5,
    xmm6,
    xmm7,
    xmm8,
    xmm9,
    xmm10,
    xmm11,
    xmm12,
    xmm13,
    xmm14,
    xmm15,

    pub fn registerType(self: @This()) RegisterType {
        return switch (self) {
            .rax, .rbx, .rcx, .rdx, .rsi, .rdi, .r8, .r9, .r10, .r11, .r12, .r13, .r14, .r15 => .gp,
            .xmm0, .xmm1, .xmm2, .xmm3, .xmm4, .xmm5, .xmm6, .xmm7, .xmm8, .xmm9, .xmm10, .xmm11, .xmm12, .xmm13, .xmm14, .xmm15 => .f,
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

// FIXME: scratch registers shouldnt have a color set
const gp_scratch_reg: PhysicalReg = X86Register.r11.physical(0, 8);

/// general purpose function param registers
const gp_function_param_regs = [_]PhysicalReg{
    X86Register.rdi.physical(0, 8),
    X86Register.rsi.physical(1, 8),
    X86Register.rdx.physical(2, 8),
    X86Register.rcx.physical(3, 8),
    X86Register.r8.physical(4, 8),
    X86Register.r9.physical(5, 8),
};

/// general purpose callee save registers
const gp_callee_save_regs = [_]PhysicalReg{ X86Register.rbx.physical(8, 8), X86Register.r12.physical(9, 8), X86Register.r13.physical(10, 8), X86Register.r14.physical(11, 8), X86Register.r15.physical(12, 8) };

/// general purpose caller save registers
const gp_caller_save_regs = [_]PhysicalReg{ X86Register.rax.physical(6, 8), X86Register.r10.physical(7, 8) };

// FIXME: scratch registers shouldnt have a color set
const fp_scratch_reg = X86Register.xmm15.physical(0, 8);

const fp_function_param_regs = [_]PhysicalReg{
    X86Register.xmm0.physical(0, 8),
    X86Register.xmm1.physical(1, 8),
    X86Register.xmm2.physical(2, 8),
    X86Register.xmm3.physical(3, 8),
    X86Register.xmm4.physical(4, 8),
    X86Register.xmm5.physical(5, 8),
    X86Register.xmm6.physical(6, 8),
    X86Register.xmm7.physical(7, 8),
};

const fp_caller_save_regs = [_]PhysicalReg{
    X86Register.xmm8.physical(8, 8),
    X86Register.xmm9.physical(9, 8),
    X86Register.xmm10.physical(10, 8),
    X86Register.xmm11.physical(11, 8),
    X86Register.xmm12.physical(12, 8),
    X86Register.xmm13.physical(13, 8),
    X86Register.xmm14.physical(14, 8),
};

const fp_callee_save_regs = [_]PhysicalReg{};

pub fn getRegisterName(register: PhysicalReg) []const u8 {
    const x86_register: X86Register = @enumFromInt(register.id);
    return @tagName(x86_register);
}

pub const X86Abi = Abi.init(
    &gp_function_param_regs,
    &gp_caller_save_regs,
    &gp_callee_save_regs,
    6,
    &.{gp_scratch_reg},
    &fp_function_param_regs,
    &fp_caller_save_regs,
    &fp_callee_save_regs,
    0,
    &.{fp_scratch_reg},
    getRegisterName,
);
