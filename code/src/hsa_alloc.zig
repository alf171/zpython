const std = @import("std");
pub const hsa = @import("hsa.zig").c;
const HsaAllocator = @This();

region: hsa.hsa_region_t,

pub fn allocate(self: *HsaAllocator) std.mem.Allocator {
    return .{
        .ptr = self,
        .vtable = &.{
            .alloc = alloc,
            .resize = std.mem.Allocator.noResize,
            .remap = std.mem.Allocator.noRemap,
            .free = free,
        },
    };
}

fn alloc(self: *anyopaque, len: usize, alignment: std.mem.Alignment, ret_addr: usize) ?[*]u8 {
    _ = ret_addr;
    _ = alignment;

    var memory: [*c]u64 = null;
    const state: *HsaAllocator = @ptrCast(@alignCast(self));
    const status = hsa.hsa_memory_allocate(state.region, len, @ptrCast(&memory));

    if (status != hsa.HSA_STATUS_SUCCESS) {
        return null;
    }
    // TODO: check alignment?

    const ptr = memory orelse return null;

    return @ptrCast(ptr);
}

pub fn free(self: *anyopaque, memory: []u8, alignment: std.mem.Alignment, return_addr: usize) void {
    _ = self;
    _ = alignment;
    _ = return_addr;
    const status = hsa.hsa_memory_free(memory.ptr);
    if (status != hsa.HSA_STATUS_SUCCESS) {
        @panic("hsa_memory_free failed");
    }
}
