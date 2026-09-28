const std = @import("std");
const runCommand = @import("run.zig").runCommand;
const Target = @import("backend").Target;

pub fn main(init: std.process.Init) !void {
    const arena = init.arena;
    const args = try init.minimal.args.toSlice(arena.allocator());
    // std.debug.assert(2 >= args.len and args.len <= 4);
    const io = init.io;
    var debug_alloc = std.heap.DebugAllocator(.{}){};
    defer {
        const status = debug_alloc.deinit();
        if (status == .leak) {
            std.debug.print("leaks detected\n", .{});
        }
    }
    const alloc = debug_alloc.allocator();

    var should_regen_snapshot = false;
    var target: Target = .{
        .host = .X86,
        .device = .gfx1103,
    };
    for (args[1..]) |arg| {
        if (std.mem.eql(u8, arg, "--regen")) should_regen_snapshot = true;
        if (std.mem.eql(u8, arg, "--host=arm")) target.host = .ARM;
        if (std.mem.eql(u8, arg, "--host=x86")) target.host = .X86;
        if (std.mem.eql(u8, arg, "--device=host")) target.device = .host;
    }
    const compiler_path = args[1];

    const dir = try std.Io.Dir.cwd().openDir(io, "tst/python", .{ .iterate = true });
    defer dir.close(io);

    var walker = try dir.walk(alloc);
    defer walker.deinit();

    while (try walker.next(io)) |entry| {
        if (entry.kind != .file) continue;
        const flattened_name = try std.mem.replaceOwned(
            u8,
            alloc,
            entry.path,
            std.fs.path.sep_str,
            "__",
        );
        defer alloc.free(flattened_name);
        const file_name = try std.fs.path.join(alloc, &.{ "tst/python", entry.path });
        defer alloc.free(file_name);
        run(compiler_path, file_name, flattened_name, should_regen_snapshot, target, alloc, io) catch |err| {
            std.debug.print(" [[ERROR: {s}]]\n", .{@errorName(err)});
        };
    }
}

pub fn run(
    compiler_path: []const u8,
    python_file_name: []const u8,
    snapshot_name: []const u8,
    update: bool,
    target: Target,
    alloc: std.mem.Allocator,
    io: std.Io,
) !void {
    std.debug.print("running {s}", .{python_file_name});
    const host_arg = try std.fmt.allocPrint(
        alloc,
        "--host={s}",
        .{target.host.toString()},
    );
    defer alloc.free(host_arg);
    const device_arg = try std.fmt.allocPrint(
        alloc,
        "--device={s}",
        .{try target.device.toString()},
    );
    defer alloc.free(device_arg);

    const asm_temp_path = try std.fmt.allocPrint(
        alloc,
        "/tmp/{s}.s",
        .{std.fs.path.stem(snapshot_name)},
    );
    defer alloc.free(asm_temp_path);

    const result = try runCommand(alloc, io, &.{
        compiler_path,
        python_file_name,
        asm_temp_path,
        "--run",
        "--dump-user-stats",
        "--omit-escape-codes",
        "--optim",
        host_arg,
        device_arg,
    });
    defer alloc.free(result.stdout);
    defer alloc.free(result.stderr);

    // snapshot dir
    const snapshot_dir_path = try std.fmt.allocPrint(
        alloc,
        "tst/snapshot/{s}",
        .{target.host.toString()},
    );
    defer alloc.free(snapshot_dir_path);

    const dir = try std.Io.Dir.cwd().createDirPathOpen(
        io,
        snapshot_dir_path,
        .{ .open_options = .{ .iterate = true } },
    );
    defer dir.close(io);
    const snapshot_file_name = try std.fmt.allocPrint(alloc, "{s}.snapshot", .{snapshot_name});
    defer alloc.free(snapshot_file_name);

    // verify snapshot
    const stats_path = try std.fs.path.join(alloc, &.{ snapshot_dir_path, snapshot_file_name });
    defer alloc.free(stats_path);

    const temp_stats_path = try std.fs.path.join(alloc, &.{ "/tmp", snapshot_file_name });
    defer alloc.free(temp_stats_path);
    {
        const temp_output = try std.Io.Dir.createFileAbsolute(io, temp_stats_path, .{});
        defer temp_output.close(io);
        try temp_output.writeStreamingAll(io, result.stderr);
    }

    const stats_diff = try calculateDiff(stats_path, temp_stats_path, io, alloc);
    defer alloc.free(stats_diff.stdout);
    defer alloc.free(stats_diff.stderr);
    // verify asm
    const asm_file_path = try std.fmt.allocPrint(alloc, "tst/snapshot/{s}/asm/{s}.s", .{ target.host.toString(), std.fs.path.stem(snapshot_name) });
    defer alloc.free(asm_file_path);
    const asm_diff = try calculateDiff(asm_file_path, asm_temp_path, io, alloc);
    defer alloc.free(asm_diff.stdout);
    defer alloc.free(asm_diff.stderr);

    const stats_diff_detected = stats_diff.term.exited == 1;
    const asm_diff_deteched = asm_diff.term.exited == 1;

    // perform snapshotting
    if (update) {
        // NOTE: should check if asm_code changed also
        if (stats_diff_detected and asm_diff_deteched) {
            std.debug.print(" [[EQUAL]]\n", .{});
            return;
        }
        const snapshot_file = try dir.createFile(io, snapshot_file_name, .{});
        defer snapshot_file.close(io);

        var snapshot_file_buf: [1028]u8 = undefined;
        var snapshot_file_writer: std.Io.File.Writer = .init(snapshot_file, io, &snapshot_file_buf);
        try snapshot_file_writer.interface.writeAll(result.stderr);
        try snapshot_file_writer.interface.flush();

        const asm_file = try std.Io.Dir.cwd().createFile(io, asm_file_path, .{});
        defer asm_file.close(io);
        const generated_asm = try std.Io.Dir.cwd().readFileAlloc(io, asm_temp_path, alloc, .limited(1 << 24));
        defer alloc.free(generated_asm);
        try asm_file.writeStreamingAll(io, generated_asm);

        std.debug.print(" [[REGENERATED]]\n", .{});
        return;
    }

    // snapshot missing
    dir.access(io, snapshot_file_name, .{}) catch |err| switch (err) {
        error.FileNotFound => {
            std.debug.print(" [[SNAPSHOT MISSING]]\n", .{});
            return error.MissingSnapshot;
        },
        else => return err,
    };

    if (!stats_diff_detected and !asm_diff_deteched) {
        std.debug.print(" [[EQUAL]]\n", .{});
        return;
    } else {
        std.debug.print(" [[NOT EQUAL]]\n", .{});
        if (stats_diff_detected) {
            std.debug.print("{s}", .{stats_diff.stdout});
        }
        if (asm_diff_deteched) {
            std.debug.print("{s}", .{asm_diff.stdout});
        }
        return error.SnapshotMismatch;
    }
    return error.CommandFailed;
}

pub fn calculateDiff(snapshot_path: []const u8, generated_path: []const u8, io: std.Io, alloc: std.mem.Allocator) !std.process.RunResult {
    const snapshot_diff = try std.process.run(alloc, io, .{ .argv = &.{
        "git",
        "diff",
        "--no-index",
        "--color=always",
        "--",
        snapshot_path,
        generated_path,
    } });
    return snapshot_diff;
}
