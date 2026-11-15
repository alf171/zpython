const std = @import("std");
const runCommand = @import("shared.zig").runCommand;
const AssemblerRequest = @import("shared.zig").AssemblerRequest;

pub fn assemble(request: AssemblerRequest, io: std.Io, alloc: std.mem.Allocator) !void {
    // clang -c /tmp/host.s -o /tmp/host.o
    const clang_object_result = try runCommand(
        alloc,
        io,
        &.{ "clang", "-c", request.input_file, "-o", request.output_file },
    );
    defer alloc.free(clang_object_result.stdout);
    defer alloc.free(clang_object_result.stderr);
    // clang -c src/malloc.c -o /tmp/malloc.o
    const clang_malloc_result = try runCommand(alloc, io, &.{
        "clang",
        "-c",
        "src/malloc.c",
        "-o",
        "/tmp/malloc.o",
    });
    defer alloc.free(clang_malloc_result.stdout);
    defer alloc.free(clang_malloc_result.stderr);
}
