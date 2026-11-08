const std = @import("std");
const python = @import("python.zig");
const c = python.c;

pub fn report(node: *c.PyObject, file: ?[]const u8, comptime fmt: []const u8, args: anytype) void {
    const line_obj = c.PyObject_GetAttrString(node, "lineno").?;
    defer c.Py_DecRef(line_obj);

    const col_obj = c.PyObject_GetAttrString(node, "col_offset").?;
    defer c.Py_DecRef(col_obj);

    std.debug.print("{s}:{d}:{d}: error: ", .{
        file orelse "<unknown>",
        c.PyLong_AsLong(line_obj),
        c.PyLong_AsLong(col_obj) + 1,
    });
    std.debug.print(fmt, args);
    std.debug.print("\n", .{});
}
