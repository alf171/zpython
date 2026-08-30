const std = @import("std");
const ArrayList = std.ArrayList;
const LoadedModule = @import("module.zig").LoadedModule;
const ImportEdge = @import("module.zig").ImportEdge;
const PyObject = @import("python.zig").PyObject;
const ModuleId = @import("common").module.ModuleId;

pub const ModuleBuilder = struct {
    modules: ArrayList(LoadedModule),
    imports: ArrayList(ArrayList(ImportEdge)),

    pub fn init() @This() {
        return .{
            .modules = .empty,
            .imports = .empty,
        };
    }

    pub fn addModule(self: *@This(), path: []const u8, ast: *PyObject, alloc: std.mem.Allocator) !ModuleId {
        const id: ModuleId = @intCast(self.modules.items.len);

        try self.modules.append(alloc, .{
            .id = id,
            .path = try alloc.dupe(u8, path),
            .ast = ast,
        });
        try self.imports.append(alloc, .empty);

        return id;
    }

    pub fn addImport(self: *@This(), from: ModuleId, to: ModuleId, name: []const u8, alloc: std.mem.Allocator) !void {
        try self.imports.items[from].append(alloc, .{
            .from = from,
            .to = to,
            .name = try alloc.dupe(u8, name),
        });
    }
};
