const std = @import("std");
const Operand = @import("common").alloc.Operand;
const ValueRef = @import("common").ir.ValueRef;
const TypeInfo = @import("common").types.TypeInfo;
const RegisterClass = @import("common").register.RegisterClass;
const RegisterFile = @import("common").register.RegisterFile;
const RegisterType = @import("common").register.RegisterType;
const PhysicalReg = @import("common").ir.PhysicalReg;

pub const RegisterUsage = struct {
    vgpr_next: u16,
    sgpr_next: u16,
};

pub const GpuReg = struct {
    reg_type: RegisterType,
    base: u16,
    count: u8,

    pub fn toString(self: @This(), alloc: std.mem.Allocator) ![]const u8 {
        const reg_type = switch (self.reg_type) {
            .vgpr => "v",
            .sgpr => "s",
            else => unreachable,
        };
        return try std.fmt.allocPrint(alloc, "{s}{d}", .{ reg_type, self.base });
    }

    pub fn toStringAt(self: @This(), offset: u8, alloc: std.mem.Allocator) ![]const u8 {
        const reg_type = switch (self.reg_type) {
            .vgpr => "v",
            .sgpr => "s",
            else => unreachable,
        };
        return try std.fmt.allocPrint(alloc, "{s}{d}", .{ reg_type, self.base + offset });
    }
};

pub const GpuAbi = struct {
    sgpr_allocatable_regs: []const PhysicalReg,
    vgpr_allocatable_regs: []const PhysicalReg,
    sgpr_scratch_regs: []const PhysicalReg,
    vgpr_scratch_regs: []const PhysicalReg,

    pub fn init(
        sgpr_allocatable_regs: []const PhysicalReg,
        vgpr_allocatable_regs: []const PhysicalReg,
        sgpr_scratch_regs: []const PhysicalReg,
        vgpr_scratch_regs: []const PhysicalReg,
    ) @This() {
        return .{
            .sgpr_allocatable_regs = sgpr_allocatable_regs,
            .vgpr_allocatable_regs = vgpr_allocatable_regs,
            .sgpr_scratch_regs = sgpr_scratch_regs,
            .vgpr_scratch_regs = vgpr_scratch_regs,
        };
    }

    pub fn regForColor(self: @This(), color: usize, class: RegisterClass) !PhysicalReg {
        const allocatable_regs = switch (class.type) {
            .vgpr => self.vgpr_allocatable_regs,
            .sgpr => self.sgpr_allocatable_regs,
            else => unreachable,
        };
        if (color >= allocatable_regs.len) return error.TooManyArgs;
        var reg = allocatable_regs[color];
        // recalculate width since we cant assume constant width
        reg.width = class.count * class.type.width();
        return reg;
    }

    pub fn regFor(self: @This(), op: Operand) !GpuReg {
        switch (op) {
            .reg => |reg| {
                const physical_reg = try self.regForColor(reg.id, .{
                    .count = reg.count(),
                    .type = reg.type,
                });
                return .{
                    .reg_type = physical_reg.type,
                    .base = physical_reg.id,
                    .count = physical_reg.count(),
                };
            },
            else => return error.UnsupportedOperand,
        }
    }

    pub fn scratchReg(self: @This(), index: usize, count: u8, reg_type: RegisterType) !GpuReg {
        const regs = switch (reg_type) {
            .vgpr => self.vgpr_scratch_regs,
            .sgpr => self.sgpr_scratch_regs,
            else => unreachable,
        };

        if (count == 0 or index + count > regs.len)
            return error.InvalidScratchReg;

        const reg = regs[index];
        return .{
            .base = reg.id,
            .count = count,
            .reg_type = reg_type,
        };
    }

    pub fn registerFiles(self: @This()) [2]RegisterFile {
        return .{
            .{
                .count = @intCast(self.vgpr_allocatable_regs.len),
                .type = .vgpr,
                .forbidden_mask = 0,
            },
            .{
                .count = @intCast(self.sgpr_allocatable_regs.len),
                .type = .sgpr,
                .forbidden_mask = 0,
            },
        };
    }

    pub fn registerUsage(self: @This()) !RegisterUsage {
        var usage: RegisterUsage = .{
            // v0 contains work items (x=bits[0-9],y=bits[10,19],z=bits[20-20])
            .vgpr_next = 1,
            //s[0:1] = kernarg pointer, s[2] work group
            .sgpr_next = 4,
        };

        for (self.vgpr_scratch_regs) |reg| {
            usage.vgpr_next = @max(usage.vgpr_next, reg.id + 1);
        }

        for (self.sgpr_scratch_regs) |reg| {
            usage.sgpr_next = @max(usage.sgpr_next, reg.id + 1);
        }
        return usage;
    }
};
