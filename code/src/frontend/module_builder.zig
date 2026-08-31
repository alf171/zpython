const std = @import("std");
const ArrayList = std.ArrayList;
const LoadedModule = @import("module.zig").LoadedModule;
const ImportEdge = @import("module.zig").ImportEdge;
const parseModule = @import("module.zig").parseModule;
const PyObject = @import("python.zig").PyObject;
const ModuleId = @import("common").module.ModuleId;
const FunctionType = @import("common").ir.FunctionType;

pub const ModuleBuilder = struct {
    runtime_modules: ArrayList(ModuleId),
    modules: ArrayList(LoadedModule),
    imports: ArrayList(ArrayList(ImportEdge)),

    pub fn init() @This() {
        return .{
            .runtime_modules = .empty,
            .modules = .empty,
            .imports = .empty,
        };
    }

    pub fn addModule(
        self: *@This(),
        path: []const u8,
        ast: *PyObject,
        origin: FunctionType,
        alloc: std.mem.Allocator,
    ) !ModuleId {
        const id: ModuleId = @intCast(self.modules.items.len);
        const name = std.fs.path.stem(path);

        try self.modules.append(alloc, .{
            .id = id,
            .name = try alloc.dupe(u8, name),
            .path = try alloc.dupe(u8, path),
            .ast = ast,
            .origin = origin,
        });
        try self.imports.append(alloc, .empty);

        return id;
    }

    pub fn addRuntimeModule(self: *@This(), path: []const u8, ast: *PyObject, alloc: std.mem.Allocator) !ModuleId {
        const id = try self.addModule(path, ast, .runtime, alloc);
        try self.runtime_modules.append(alloc, id);
        return id;
    }

    pub fn addImport(self: *@This(), from: ModuleId, to: ModuleId, name: []const u8, alloc: std.mem.Allocator) !void {
        try self.imports.items[from].append(alloc, .{
            .from = from,
            .to = to,
            .name = try alloc.dupe(u8, name),
        });
    }

    pub fn loadRuntime(self: *@This(), io: std.Io, alloc: std.mem.Allocator) !void {
        const dir = try std.Io.Dir.cwd().openDir(io, "src/runtime", .{ .iterate = true });
        defer dir.close(io);

        var walker = try dir.walk(alloc);
        defer walker.deinit();

        while (try walker.next(io)) |entry| {
            std.debug.assert(entry.kind == .file);
            // std.debug.print("check {s}\n", .{entry.path});
            const file_name = try std.fs.path.join(alloc, &.{ "src/runtime", entry.path });
            defer alloc.free(file_name);
            const ast = try parseModule(file_name, io, alloc);
            _ = try self.addRuntimeModule(file_name, ast, alloc);
        }
    }
};
