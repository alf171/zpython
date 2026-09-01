const std = @import("std");
const ArrayList = std.ArrayList;
const python = @import("python.zig");
const c = python.c;
const PyObject = c.PyObject;
const ModuleId = @import("common").module.ModuleId;
const printAstDump = @import("python.zig").printAstDump;
const ModuleBuilder = @import("module_builder.zig").ModuleBuilder;
const IrBuilder = @import("ir_builder.zig").IrBuilder;
const walkAstIntoBuilder = @import("walk.zig").walkAstIntoBuilder;
const FunctionType = @import("common").ir.FunctionType;

pub const LoadOptions = struct {
    module_root: []const u8,
    std_lib_enabled: bool,
};

pub const LoadedModule = struct {
    id: ModuleId,
    name: []const u8,
    path: []const u8,
    ast: *PyObject,
    origin: FunctionType,

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        alloc.free(self.name);
        alloc.free(self.path);
    }
};

pub const ImportEdge = struct {
    from: ModuleId,
    to: ModuleId,
    name: []const u8,

    pub fn deinit(self: @This(), alloc: std.mem.Allocator) void {
        alloc.free(self.name);
    }
};

pub const ModuleGraph = struct {
    entry: ModuleId,
    runtime_modules: []ModuleId,
    modules: []LoadedModule,
    imports: [][]ImportEdge,

    pub fn walkModule(self: *const @This(), id: ModuleId, ir_builder: *IrBuilder, alloc: std.mem.Allocator) !void {
        for (self.imports[id]) |import| {
            try self.walkModule(import.to, ir_builder, alloc);
        }
        ir_builder.current_module_id = id;
        ir_builder.current_imports = self.imports[id];
        ir_builder.current_module_name = self.modules[id].name;

        try walkAstIntoBuilder(self.modules[id].ast, ir_builder, alloc);
    }

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        for (self.modules) |*module| {
            module.deinit(alloc);
        }
        alloc.free(self.modules);
        for (self.imports) |module_imports| {
            for (module_imports) |import| {
                import.deinit(alloc);
            }
            alloc.free(module_imports);
        }
        alloc.free(self.imports);
        alloc.free(self.runtime_modules);
    }
};

/// walk python program for imports
pub fn parseModule(path: []const u8, io: std.Io, alloc: std.mem.Allocator) !*PyObject {
    const code = try std.Io.Dir.cwd().readFileAlloc(io, path, alloc, .limited(1 << 20));
    defer alloc.free(code);
    const code_z = try alloc.dupeSentinel(u8, code, 0);
    defer alloc.free(code_z);
    const ast_module = c.PyImport_ImportModule("ast");
    const parse_fn = c.PyObject_GetAttrString(ast_module, "parse");
    std.debug.assert(parse_fn != null);
    const tree = c.PyObject_CallFunction(parse_fn, "s", code_z.ptr);
    std.debug.assert(tree != null);
    return tree;
}

pub fn loadGraph(
    entry_path: []const u8,
    options: LoadOptions,
    io: std.Io,
    alloc: std.mem.Allocator,
) !ModuleGraph {
    var builder: ModuleBuilder = .init(alloc);
    defer builder.deinit();
    errdefer builder.deinitContents(alloc);

    // walk runtime
    if (options.std_lib_enabled) {
        try builder.loadRuntime(io, alloc);
    }

    const id = try loadModule(&builder, entry_path, .user, io, alloc);
    const imports = try alloc.alloc([]ImportEdge, builder.imports.items.len);
    for (builder.imports.items, 0..) |*module_imports, i| {
        imports[i] = try module_imports.toOwnedSlice(alloc);
    }
    builder.imports.deinit(alloc);
    return .{
        .entry = id,
        .modules = try builder.modules.toOwnedSlice(alloc),
        .imports = imports,
        .runtime_modules = try builder.runtime_modules.toOwnedSlice(alloc),
    };
}

pub fn loadModule(
    builder: *ModuleBuilder,
    path: []const u8,
    origin: FunctionType,
    io: std.Io,
    alloc: std.mem.Allocator,
) !ModuleId {
    if (builder.modules_by_path.get(path)) |status| {
        if (status.state == .loading) {
            return error.ImportCycle;
        }
        return status.id;
    }
    const ast = try parseModule(path, io, alloc);
    const id = try builder.addModule(path, ast, origin, alloc);
    builder.modules_by_path.getPtr(path).?.state = .loading;

    // walk imports
    const body = c.PyObject_GetAttrString(ast, "body") orelse {
        return error.InvalidModuleAst;
    };
    for (0..@intCast(c.PyList_Size(body))) |stmt_i| {
        const stmt = c.PyList_GetItem(body, @intCast(stmt_i));
        std.debug.assert(stmt != null);
        switch (python.getStmtKind(stmt)) {
            .Import => {
                const names_obj = c.PyObject_GetAttrString(stmt, "names");
                std.debug.assert(names_obj != null);
                for (0..@intCast(c.PyList_Size(names_obj))) |names_i| {
                    const alias_obj = c.PyList_GetItem(names_obj, @intCast(names_i));
                    std.debug.assert(alias_obj != null);
                    const name_obj = c.PyObject_GetAttrString(alias_obj, "name");
                    std.debug.assert(name_obj != null);
                    const name = c.PyUnicode_AsUTF8(name_obj);
                    std.debug.assert(name != null);
                    const name_slice = std.mem.span(name);

                    const imported_dir = std.fs.path.dirname(path) orelse ".";
                    const imported_path = try std.fmt.allocPrint(alloc, "{s}/{s}.py", .{ imported_dir, name_slice });
                    defer alloc.free(imported_path);
                    // recursively build imports module
                    const import_id = try loadModule(builder, imported_path, origin, io, alloc);
                    try builder.addImport(id, import_id, name_slice, alloc);
                }
            },
            .ImportFrom => {
                printAstDump(stmt);
            },
            else => {},
        }
    }
    builder.modules_by_path.getPtr(path).?.state = .loaded;
    return id;
}
