const std = @import("std");
const ArrayList = std.ArrayList;
const LoadedModule = @import("module.zig").LoadedModule;
const ImportEdge = @import("module.zig").ImportEdge;
const parseModule = @import("module.zig").parseModule;
const PyObject = @import("python.zig").PyObject;
const ModuleId = @import("common").module.ModuleId;
const FunctionType = @import("common").ir.FunctionType;

const ModuleStatus = struct {
    id: ModuleId,
    state: enum { loading, loaded },
};

pub const ModuleBuilder = struct {
    runtime_modules: ArrayList(ModuleId),
    modules: ArrayList(LoadedModule),
    imports: ArrayList(ArrayList(ImportEdge)),
    dependencies: ArrayList(ArrayList(ModuleId)),
    modules_by_path: std.StringHashMap(ModuleStatus),

    pub fn init(alloc: std.mem.Allocator) @This() {
        return .{
            .runtime_modules = .empty,
            .modules = .empty,
            .imports = .empty,
            .dependencies = .empty,
            .modules_by_path = .init(alloc),
        };
    }

    pub fn deinit(self: *@This()) void {
        self.modules_by_path.deinit();
    }

    pub fn deinitContents(self: *@This(), alloc: std.mem.Allocator) void {
        for (self.modules.items) |*module| {
            module.deinit(alloc);
        }
        self.modules.deinit(alloc);

        for (self.imports.items) |*module_imports| {
            for (module_imports.items) |*imports| {
                imports.deinit(alloc);
            }
            module_imports.deinit(alloc);
        }
        self.imports.deinit(alloc);
        self.runtime_modules.deinit(alloc);
        for (self.dependencies.items) |*deps| {
            deps.deinit(alloc);
        }
        self.dependencies.deinit(alloc);
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
        try self.dependencies.append(alloc, .empty);
        try self.imports.append(alloc, .empty);
        try self.modules_by_path.put(self.modules.items[id].path, .{
            .id = id,
            .state = .loaded,
        });

        return id;
    }

    pub fn addRuntimeModule(self: *@This(), path: []const u8, ast: *PyObject, alloc: std.mem.Allocator) !ModuleId {
        const id = try self.addModule(path, ast, .runtime, alloc);
        try self.runtime_modules.append(alloc, id);
        return id;
    }

    pub fn addDependency(self: *@This(), from: ModuleId, to: ModuleId, alloc: std.mem.Allocator) !void {
        for (self.dependencies.items[from].items) |existing| {
            if (existing == to) return;
        }
        try self.dependencies.items[from].append(alloc, to);
    }

    pub fn addModuleImport(
        self: *@This(),
        from: ModuleId,
        id: ModuleId,
        name: []const u8,
        alloc: std.mem.Allocator,
    ) !void {
        try self.imports.items[from].append(alloc, .{ .module = .{
            .id = id,
            .name = try alloc.dupe(u8, name),
        } });
    }

    pub fn addFunctionImport(
        self: *@This(),
        from: ModuleId,
        id: ModuleId,
        function_name: []const u8,
        alias: ?[]const u8,
        alloc: std.mem.Allocator,
    ) !void {
        try self.imports.items[from].append(alloc, .{ .function = .{
            .id = id,
            .function_name = try alloc.dupe(u8, function_name),
            .alias = if (alias) |a| try alloc.dupe(u8, a) else null,
        } });
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
