const std = @import("std");
pub const python = @import("python.zig");
pub const walk = @import("walk.zig");
pub const run = @import("run.zig");
pub const builder = @import("ir_builder.zig");
pub const tuple = @import("passes/tuple.zig");
pub const lazy = @import("passes/lazy.zig");
pub const list = @import("passes/list.zig");
pub const inline_ = @import("passes/inline.zig");
pub const func = @import("passes/func.zig");
pub const gpu = @import("passes/gpu.zig");
pub const print = @import("passes/print.zig");
pub const class = @import("passes/class.zig");
pub const runtime = @import("runtime.zig");
pub const repeat = @import("passes/repeat.zig");
pub const generics = @import("passes/generics.zig");
pub const module = @import("module.zig");

test {
    std.testing.refAllDecls(@This());
}
