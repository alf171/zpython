const std = @import("std");

pub const program = @import("program.zig");
pub const mir = @import("mir.zig");
pub const lir = @import("lir.zig");
pub const ir = @import("ir.zig");
pub const alloc = @import("alloc.zig");
pub const types = @import("types.zig");
pub const register = @import("register.zig");
pub const timer = @import("timer.zig");
pub const module = @import("module.zig");

test {
    std.testing.refAllDecls(@This());
}
