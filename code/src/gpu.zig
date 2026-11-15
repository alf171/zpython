const std = @import("std");
const HsaAlloc = @import("hsa_alloc.zig");
const hsa = @import("hsa.zig").c;
const libc = @cImport({
    @cUndef("_FORTIFY_SOURCE");
    @cDefine("_FORTIFY_SOURCE", "0");
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
    @cInclude("fcntl.h");
    @cInclude("unistd.h");
});

const l = @cImport({
    @cInclude("gpu_layout.h");
});

pub const LaunchDims = struct {
    x: u32,
    y: u32,
    z: u32,
};

pub const GpuRuntime = struct {
    agent: hsa.hsa_agent_t,
    executable: hsa.hsa_executable_t,
    queue: ?*hsa.hsa_queue_t,
    hsa_alloc: HsaAlloc,
    arena: std.heap.ArenaAllocator,
};

fn check(status: hsa.hsa_status_t, operation: []const u8) void {
    if (status == hsa.HSA_STATUS_SUCCESS) {
        return;
    }

    var message: [*c]const u8 = null;
    _ = hsa.hsa_status_string(status, &message);

    std.debug.panic("{s} failed: {s}\n", .{ operation, if (message != null) std.mem.span(message) else "unknown hsa" });
}

fn find_gpu(agent: hsa.hsa_agent_t, data: ?*anyopaque) callconv(.c) hsa.hsa_status_t {
    var device_type: hsa.hsa_device_type_t = undefined;
    const status: hsa.hsa_status_t = hsa.hsa_agent_get_info(agent, hsa.HSA_AGENT_INFO_DEVICE, &device_type);

    if (status != hsa.HSA_STATUS_SUCCESS) {
        return status;
    }

    if (device_type == hsa.HSA_DEVICE_TYPE_GPU) {
        const output: *hsa.hsa_agent_t = @ptrCast(@alignCast(data.?));
        output.* = agent;
    }

    return hsa.HSA_STATUS_SUCCESS;
}

fn find_kernarg_region(region: hsa.hsa_region_t, data: ?*anyopaque) callconv(.c) hsa.hsa_status_t {
    var segment: hsa.hsa_region_segment_t = undefined;

    var status: hsa.hsa_status_t = hsa.hsa_region_get_info(region, hsa.HSA_REGION_INFO_SEGMENT, &segment);
    if (status != hsa.HSA_STATUS_SUCCESS) {
        return status;
    }

    if (segment != hsa.HSA_REGION_SEGMENT_GLOBAL) {
        return hsa.HSA_STATUS_SUCCESS;
    }

    var flags: i32 = 0;
    status = hsa.hsa_region_get_info(region, hsa.HSA_REGION_INFO_GLOBAL_FLAGS, &flags);

    if (status == hsa.HSA_STATUS_SUCCESS and (flags & hsa.HSA_REGION_GLOBAL_FLAG_KERNARG) != 0) {
        const output: *hsa.hsa_region_t = @ptrCast(@alignCast(data.?));
        output.* = region;
    }

    return status;
}

var runtime: GpuRuntime = .{
    .agent = .{ .handle = 0 },
    .executable = .{ .handle = 0 },
    .queue = null,
    .hsa_alloc = .{ .region = .{ .handle = 0 } },
    .arena = undefined,
};
var initialized = false;

fn shutdown_hsa() callconv(.c) void {
    if (runtime.queue != null) {
        check(hsa.hsa_queue_destroy(runtime.queue), "hsa_queue_destroy");
    }
    check(hsa.hsa_executable_destroy(runtime.executable), "hsa_executable_destroy");
    runtime.arena.deinit();
    check(hsa.hsa_shut_down(), "hsa_shut_down");
}

fn ensure_hsa_initialized() void {
    if (initialized) return;

    check(hsa.hsa_init(), "hsa_init");
    if (libc.atexit(shutdown_hsa) != 0) libc.abort();

    // agent
    check(hsa.hsa_iterate_agents(find_gpu, &runtime.agent), "hsa_iterate_agents");
    if (runtime.agent.handle == 0) {
        @panic("no hsa gpu agent found\n");
    }

    // executable
    var profile: hsa.hsa_profile_t = undefined;
    check(hsa.hsa_agent_get_info(runtime.agent, hsa.HSA_AGENT_INFO_PROFILE, &profile), "hsa_agent_get_info(PROFILE)");
    const code_object_fd: c_int = libc.open("/tmp/device.co", libc.O_RDONLY);
    if (code_object_fd < 0) {
        libc.perror("open /tmp/device.co");
        libc.abort();
    }
    var reader: hsa.hsa_code_object_reader_t = undefined;
    check(hsa.hsa_code_object_reader_create_from_file(code_object_fd, &reader), "hsa_code_object_reader_create_from_file");
    check(hsa.hsa_executable_create_alt(profile, hsa.HSA_DEFAULT_FLOAT_ROUNDING_MODE_DEFAULT, null, &runtime.executable), "hsa_executable_create_alt");
    var loaded_code_obj: hsa.hsa_loaded_code_object_t = undefined;
    check(hsa.hsa_executable_load_agent_code_object(runtime.executable, runtime.agent, reader, null, &loaded_code_obj), "hsa_executable_load_agent_code_object");
    check(hsa.hsa_executable_freeze(runtime.executable, null), "hsa_executable_freeze");
    // destroy
    check(hsa.hsa_code_object_reader_destroy(reader), "hsa_code_object_reader_destroy");
    _ = libc.close(code_object_fd);
    // queue
    var queue_max_size: u32 = 0;
    check(hsa.hsa_agent_get_info(runtime.agent, hsa.HSA_AGENT_INFO_QUEUE_MAX_SIZE, &queue_max_size), "hsa_agent_get_info");
    check(hsa.hsa_queue_create(runtime.agent, queue_max_size, hsa.HSA_QUEUE_TYPE_SINGLE, null, null, std.math.maxInt(u32), std.math.maxInt(u32), &runtime.queue), "hsa_queue_create");
    // prepare allocator
    check(hsa.hsa_agent_iterate_regions(runtime.agent, find_kernarg_region, &runtime.hsa_alloc.region), "hsa_agent_iterate_regions");
    if (runtime.hsa_alloc.region.handle == 0) {
        @panic("No kernarg region found\n");
    }
    runtime.arena = std.heap.ArenaAllocator.init(runtime.hsa_alloc.allocate());

    initialized = true;
}

export fn gpu_launch(
    arg_slots: [*]const u64,
    arg_count: u64,
    workitems: [*]const u64,
    kernel_name_slots: [*]const i64,
) callconv(.c) void {
    // TEMP: hack since tuples dont map 1 to 1 with strings (namely always 8 bytes)
    var symbol_name: [256]u8 = @splat(0);
    var index: u64 = 0;

    while (index < symbol_name.len - 1) : (index += 1) {
        const ch: u8 = @as([*]const u8, @ptrCast(kernel_name_slots))[index * @sizeOf(u64)];

        symbol_name[index] = ch;

        if (ch == '\x00') {
            break;
        }
    }
    const suffix = ".kd";
    @memcpy(symbol_name[index..][0..suffix.len], suffix);
    // fprintf(stderr, "Looking up kernel symbol: '%s'\n", symbol_name);
    const dims: LaunchDims = .{
        .x = @truncate(workitems[0]),
        .y = @truncate(workitems[1]),
        .z = @truncate(workitems[2]),
    };

    // fprintf(stderr, "grid: %u x %u x %u\n", dims.x, dims.y, dims.z);

    var rank: u16 = undefined;
    if (dims.z != 1) {
        rank = 3;
    } else if (dims.y != 1) {
        rank = 2;
    } else {
        rank = 1;
    }

    ensure_hsa_initialized();

    var max_workgroup_size: u32 = undefined;
    var max_workgroup_dims: [3]u16 = undefined;
    check(hsa.hsa_agent_get_info(runtime.agent, hsa.HSA_AGENT_INFO_WORKGROUP_MAX_SIZE, &max_workgroup_size), "hsa_agent_get_info(WORKGROUP_MAX_SIZE)");
    check(hsa.hsa_agent_get_info(runtime.agent, hsa.HSA_AGENT_INFO_WORKGROUP_MAX_DIM, &max_workgroup_dims), "hsa_agent_get_info(WORKGROUP_MAX_DIM)");
    const grid: [3]u32 = .{ dims.x, dims.y, dims.z };
    var group: [3]u16 = undefined;
    var budget: u32 = 256;
    var axis: u64 = 0;
    while (axis < 3) : (axis += 1) {
        var size: u16 = @intCast(if (grid[axis] < budget) grid[axis] else budget);
        while (grid[axis] % size != 0) size -= 1;
        group[axis] = size;
        budget /= size;
    }

    var name: [64]u8 = @splat(0);
    check(hsa.hsa_agent_get_info(runtime.agent, hsa.HSA_AGENT_INFO_NAME, &name), "hsa_agent_info(name)");

    var kernel_symbol: hsa.hsa_executable_symbol_t = undefined;
    check(hsa.hsa_executable_get_symbol_by_name(runtime.executable, &symbol_name, &runtime.agent, &kernel_symbol), "hsa_executable_get_symbol_by_name");

    var kernel_object: u64 = 0;
    check(hsa.hsa_executable_symbol_get_info(kernel_symbol, hsa.HSA_EXECUTABLE_SYMBOL_INFO_KERNEL_OBJECT, &kernel_object), "hsa_executable_symbol_get_info");

    // fprintf(stderr, "Loaded kernel.kd: kernel object=0x%lx\n", kernel_object);

    var completion_signal: hsa.hsa_signal_t = undefined;
    check(hsa.hsa_signal_create(1, 0, null, &completion_signal), "hsa_signal_create");
    // fprintf(stderr, "Created queue: id=%ld size=%u signal=%lu\n", shared_queue->id, shared_queue->size, completion_signal.handle);

    const alloc = runtime.arena.allocator();
    const kernel_args = alloc.alloc(u64, @intCast(arg_count)) catch {
        @panic("kernel allocation failed");
    };
    defer _ = runtime.arena.reset(.retain_capacity);
    // const argument_device_ptrs: [*c]?*anyopaque = libc.calloc(arg_count, @sizeOf(argument_device_ptrs));
    const argument_device_ptrs: [*c]?*anyopaque = @ptrCast(@alignCast(libc.calloc(@intCast(arg_count), @sizeOf(?*anyopaque)) orelse {
        @panic("calloc failed");
    }));
    for (0..arg_count) |i| {
        // fprintf(
        //   stderr,
        //   "arg[%lu] value=%#lx bytes=%lu layout=%#lx\n",
        //   i,
        //   arg_slots[3 * i],
        //   arg_slots[3 * i + 1],
        //   arg_slots[3 * i + 2]
        // );
        const byte_count: u64 = arg_slots[3 * i + 1];
        const layout: ?*const l.GpuInstanceLayout = @ptrFromInt(arg_slots[3 * i + 2]);
        if (byte_count != 0) {
            const instance_host_ptr: *anyopaque = @ptrFromInt(arg_slots[3 * i]);
            if (layout != null) {
                for (0..layout.?.list_field_count) |j| {
                    const field = &layout.?.list_fields[j];
                    var array_host_ptr: *anyopaque = undefined;
                    const instance_bytes: [*c]const u8 = @ptrCast(instance_host_ptr);
                    @memcpy(std.mem.asBytes(&array_host_ptr), instance_bytes[field.offset..][0..@sizeOf(@TypeOf(array_host_ptr))]);
                    const count: u64 = @as(*align(1) const u64, @ptrCast(array_host_ptr)).*;

                    const bytes: usize = @sizeOf(u64) + count * field.element_size;
                    var array_device_ptr: ?*anyopaque = null;
                    check(hsa.hsa_amd_memory_lock(array_host_ptr, bytes, &runtime.agent, 1, &array_device_ptr), "hsa_amd_memory_lock");
                    // fprintf(stderr, "list host=%p device=%p\n", array_host_ptr, array_device_ptr);
                }
            }
            check(hsa.hsa_amd_memory_lock(instance_host_ptr, byte_count, &runtime.agent, 1, &argument_device_ptrs[i]), "hsa_amd_memory_lock");
            kernel_args[i] = @intFromPtr(argument_device_ptrs[i].?);
        } else {
            kernel_args[i] = arg_slots[3 * i];
        }
    }

    const packet_id: u64 = hsa.hsa_queue_add_write_index_relaxed(runtime.queue, 1);
    const packet_index: u32 = @intCast(packet_id & (runtime.queue.?.size - 1));
    const packets: [*]hsa.hsa_kernel_dispatch_packet_t = @ptrCast(@alignCast(runtime.queue.?.base_address));
    const packet = &packets[packet_index];
    @memset(std.mem.asBytes(packet), 0);
    packet.unnamed_0.unnamed_0.setup = rank << hsa.HSA_KERNEL_DISPATCH_PACKET_SETUP_DIMENSIONS;

    packet.workgroup_size_x = group[0];
    packet.workgroup_size_y = group[1];
    packet.workgroup_size_z = group[2];
    packet.grid_size_x = dims.x;
    packet.grid_size_y = dims.y;
    packet.grid_size_z = dims.z;

    packet.private_segment_size = 0;
    packet.group_segment_size = 0;

    packet.kernel_object = kernel_object;
    packet.kernarg_address = kernel_args.ptr;
    packet.completion_signal = completion_signal;

    const header: u16 =
        (hsa.HSA_PACKET_TYPE_KERNEL_DISPATCH << hsa.HSA_PACKET_HEADER_TYPE) |
        (hsa.HSA_FENCE_SCOPE_SYSTEM << hsa.HSA_PACKET_HEADER_ACQUIRE_FENCE_SCOPE) |
        (hsa.HSA_FENCE_SCOPE_SYSTEM << hsa.HSA_PACKET_HEADER_RELEASE_FENCE_SCOPE);

    @atomicStore(u16, &packet.unnamed_0.unnamed_0.header, header, .release);

    hsa.hsa_signal_store_screlease(runtime.queue.?.doorbell_signal, @intCast(packet_id));
    _ = hsa.hsa_signal_wait_scacquire(completion_signal, hsa.HSA_SIGNAL_CONDITION_LT, 1, hsa.UINT64_MAX, hsa.HSA_WAIT_STATE_BLOCKED);

    for (0..arg_count) |i| {
        const byte_count: u64 = arg_slots[3 * i + 1];
        if (byte_count != 0) {
            const instance_host_ptr: *anyopaque = @ptrFromInt(arg_slots[3 * i]);
            check(hsa.hsa_amd_memory_unlock(instance_host_ptr), "hsa_amd_memory_unlock");
            const layout: ?*const l.GpuInstanceLayout = @ptrFromInt(arg_slots[3 * i + 2]);
            if (layout != null) {
                for (0..layout.?.list_field_count) |j| {
                    var array_host_ptr: *anyopaque = undefined;
                    var instance_bytes: [*]const u8 = @ptrCast(instance_host_ptr);
                    @memcpy(std.mem.asBytes(&array_host_ptr), instance_bytes[layout.?.list_fields[j].offset..][0..@sizeOf(@TypeOf(array_host_ptr))]);
                    check(hsa.hsa_amd_memory_unlock(array_host_ptr), "hsa_amd_memory_unlock(array)");
                }
            }
        }
    }
    libc.free(@ptrCast(argument_device_ptrs));

    check(hsa.hsa_signal_destroy(completion_signal), "hsa_signal_destroy");
}
