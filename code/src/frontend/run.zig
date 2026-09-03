const std = @import("std");
const c = @import("python.zig").c;
const PyObject = c.PyObject;
const Program = @import("common").program.Program;
const IrBuilder = @import("ir_builder.zig").IrBuilder;
const module = @import("module.zig");
const walkAstIntoBuilder = @import("walk.zig").walkAstIntoBuilder;

const underline_code = "\x1b[4m";
const reset_code = "\x1b[0m";

pub fn walkAstWithRuntime(
    user_file_name: []const u8,
    should_optim: bool,
    use_escape_codes: bool,
    std_lib_enabled: bool,
    io: std.Io,
    alloc: std.mem.Allocator,
) !Program {
    // print user source
    if (use_escape_codes) std.debug.print("{s}", .{underline_code});
    std.debug.print("running program:", .{});
    if (use_escape_codes) std.debug.print("{s}", .{reset_code});
    if (should_optim) std.debug.print(" (OPTIM={})", .{should_optim});
    const code = try std.Io.Dir.cwd().readFileAlloc(
        io,
        user_file_name,
        alloc,
        .limited(1 << 20),
    );
    defer alloc.free(code);
    std.debug.print("\n\n{s}", .{code});

    // load modules (user + runtime)
    var graph = try module.loadGraph(user_file_name, .{
        .module_root = ".",
        .std_lib_enabled = std_lib_enabled,
    }, io, alloc);
    defer graph.deinit(alloc);

    var ir_builder: IrBuilder = try .init(.runtime, graph.entry, graph.modules[graph.entry].name, alloc);
    defer ir_builder.deinit(alloc);
    errdefer ir_builder.program.deinit(alloc);

    try graph.walkAll(&ir_builder, alloc);
    return ir_builder.program;
}
