const std = @import("std");
pub const RegisterType = @import("register.zig").RegisterType;
pub const Function = @import("function.zig").Function;
pub const FunctionKind = @import("function.zig").FunctionKind;
pub const ClassId = @import("class.zig").ClassId;
pub const ConstValue = @import("ir.zig").ConstValue;
pub const TypedOperand = @import("alloc.zig").TypedOperand;
pub const ModuleId = @import("module.zig").ModuleId;
pub const Program = @import("program.zig").Program;

pub const TypeVarId = u32;

pub const TypeBindings = struct {
    bindings: std.AutoHashMap(TypeVarId, TypeInfo),

    pub fn init(alloc: std.mem.Allocator) @This() {
        return .{ .bindings = .init(alloc) };
    }

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        var it = self.bindings.valueIterator();
        while (it.next()) |_type| {
            _type.deinit(alloc);
        }
        self.bindings.deinit();
    }

    pub fn get(self: *const @This(), id: TypeVarId) ?TypeInfo {
        return self.bindings.get(id);
    }

    pub fn put(self: *@This(), id: TypeVarId, _type: TypeInfo) !void {
        return try self.bindings.put(id, _type);
    }

    pub fn inferReturnType(
        self: *@This(),
        program: *const Program,
        function: *const Function,
        args: []const TypedOperand,
        alloc: std.mem.Allocator,
    ) !TypeInfo {
        if (function.type_params.len > 0) {
            if (function.params.len != args.len) {
                std.debug.print("mismatch in function {s}\n", .{function.name});
                return error.ArgumentCountMismatch;
            }
            for (function.params, args) |param, arg| {
                try TypeInfo.unify(param.type, arg.type, self, program, alloc);
            }
        }
        const return_type = if (function.type_params.len > 0)
            try TypeInfo.substitute(function.return_type, self, alloc)
        else
            try function.return_type.clone(alloc);
        return return_type;
    }
};

pub const ClassInstance = struct {
    class_id: ClassId,
    /// used for generics
    args: []const TypeInfo,
};

// use a pointer on element type for recursive purposes
// things like range dont know their size at comptime
pub const TypeInfo = union(enum) {
    void,
    i64,
    i32,
    f64,
    f32,
    bool,
    char,
    /// size is stored in runtime header
    /// fixed size!
    array: struct {
        element: *const TypeInfo,
    },
    tuple: struct {
        elements: []const TypeInfo,
    },
    iterable: struct {
        element: *const TypeInfo,
    },
    lazy: struct {
        value: *const TypeInfo,
    },
    // struct currently not needed
    ptr,
    // model a function in type system
    callable: struct {
        params: []const TypeInfo,
        returns: *const TypeInfo,
    },
    instance: ClassInstance,
    @"enum": ClassId,
    type_variable: TypeVarId,
    module: ModuleId,
    any,

    pub fn deinit(self: @This(), alloc: std.mem.Allocator) void {
        switch (self) {
            .array => |array| {
                array.element.*.deinit(alloc);
                alloc.destroy(@constCast(array.element));
            },
            .tuple => |tuple| {
                for (tuple.elements) |elem| {
                    elem.deinit(alloc);
                }
                alloc.free(tuple.elements);
            },
            .iterable => |iterable| {
                iterable.element.*.deinit(alloc);
                alloc.destroy(@constCast(iterable.element));
            },
            .lazy => |lazy| {
                lazy.value.*.deinit(alloc);
                alloc.destroy(@constCast(lazy.value));
            },
            .callable => |callable| {
                for (callable.params) |param| {
                    param.deinit(alloc);
                }
                alloc.free(callable.params);

                callable.returns.*.deinit(alloc);
                alloc.destroy(@constCast(callable.returns));
            },
            .instance => |instance| {
                for (instance.args) |arg| {
                    arg.deinit(alloc);
                }
                alloc.free(instance.args);
            },
            else => {},
        }
    }

    pub fn clone(self: @This(), alloc: std.mem.Allocator) !@This() {
        switch (self) {
            .tuple => |t| {
                const elements = try alloc.alloc(TypeInfo, t.elements.len);
                errdefer alloc.free(elements);

                for (t.elements, 0..) |elem, i| {
                    elements[i] = try elem.clone(alloc);
                }
                return .{ .tuple = .{ .elements = elements } };
            },
            .array => |a| {
                return .{ .array = .{
                    .element = try (try a.element.*.clone(alloc)).toOwnedPointer(alloc),
                } };
            },
            .callable => |c| {
                var params = try alloc.alloc(TypeInfo, c.params.len);
                for (c.params, 0..) |param, i| {
                    params[i] = try param.clone(alloc);
                }
                return .{ .callable = .{
                    .params = params,
                    .returns = try (try c.returns.*.clone(alloc)).toOwnedPointer(alloc),
                } };
            },
            .lazy => |l| {
                return .{ .lazy = .{
                    .value = try (try l.value.*.clone(alloc)).toOwnedPointer(alloc),
                } };
            },
            .iterable => |i| {
                return .{ .iterable = .{
                    .element = try (try i.element.*.clone(alloc)).toOwnedPointer(alloc),
                } };
            },
            .instance => |instance| {
                var args = try alloc.alloc(TypeInfo, instance.args.len);
                var initialized: usize = 0;
                errdefer {
                    for (args[0..initialized]) |t| t.deinit(alloc);
                    alloc.free(args);
                }
                for (instance.args, 0..) |arg, i| {
                    args[i] = try arg.clone(alloc);
                    initialized += 1;
                }

                return .{ .instance = .{
                    .class_id = instance.class_id,
                    .args = args,
                } };
            },
            .void, .i64, .i32, .bool, .char, .f64, .f32, .any, .type_variable, .ptr, .module, .@"enum" => return self,
            // else => |e| {
            //     std.debug.print("clone does support {s}\n", .{@tagName(e)});
            //     return error.NotImpl;
            // },
        }
    }

    pub fn sizeOfType(self: @This()) !usize {
        return switch (self) {
            // instances and callables are pointers
            .i64, .array, .tuple, .ptr, .f64, .instance, .callable => 8,
            // use double for now
            .@"enum" => 8,
            .i32, .f32 => 4,
            .bool, .char => 1,
            .type_variable => return error.GenericsNotLoweredProperly,
            else => |e| {
                std.debug.print("cant handle {s}\n", .{@tagName(e)});
                return error.NotImpl;
            },
        };
    }

    /// expects a indexable input type
    pub fn getElementType(typeInfo: TypeInfo) TypeInfo {
        return switch (typeInfo) {
            .array => |array_type| array_type.element.*,
            .iterable => |it_type| it_type.element.*,
            .lazy => |lazy| getElementType(lazy.value.*),
            else => |e| {
                std.debug.print("cant handle {s}\n", .{@tagName(e)});
                unreachable;
            },
        };
    }

    pub fn isIterable(self: @This()) bool {
        return switch (self) {
            .array, .tuple, .iterable, .any => true,
            .lazy => |lazy| isIterable(lazy.value.*),
            else => false,
        };
    }

    pub fn equal(self: @This(), other: @This()) bool {
        return std.meta.activeTag(self) == std.meta.activeTag(other);
    }

    pub fn toRegisterType(self: @This(), function_kind: FunctionKind) RegisterType {
        return switch (function_kind) {
            .host => switch (self) {
                .f64, .f32 => .f,
                else => return .gp,
            },
            .gpu_kernel => .vgpr,
        };
    }

    pub fn toOwnedPointer(self: TypeInfo, alloc: std.mem.Allocator) !*TypeInfo {
        const ptr = try alloc.create(TypeInfo);
        ptr.* = self;
        return ptr;
    }

    pub fn replaceType(self: *TypeInfo, new_type: TypeInfo, alloc: std.mem.Allocator) void {
        self.deinit(alloc);
        self.* = new_type;
    }

    /// verifies generics logic
    pub fn unify(self: @This(), expected: TypeInfo, bindings: *TypeBindings, program: *const Program, alloc: std.mem.Allocator) !void {
        switch (self) {
            .type_variable => |tv| {
                if (bindings.get(tv)) |resolves| {
                    if (!resolves.equal(expected)) {
                        const lhs = try self.toString(alloc);
                        defer alloc.free(lhs);
                        const rhs = try expected.toString(alloc);
                        defer alloc.free(rhs);
                        std.debug.print("cant unify {s} with {s}\n", .{ lhs, rhs });
                        return error.TypeMismatch;
                    }
                    return;
                }
                try bindings.put(tv, try expected.clone(alloc));
            },
            .array => |generic_a| switch (expected) {
                .array => |expected_a| {
                    try unify(generic_a.element.*, expected_a.element.*, bindings, program, alloc);
                },
                else => {
                    const lhs = try self.toDisplayName(program, alloc);
                    defer alloc.free(lhs);
                    const rhs = try expected.toDisplayName(program, alloc);
                    defer alloc.free(rhs);
                    std.debug.print("cant unify {s} with {s}\n", .{ lhs, rhs });
                    return error.TypeMistmatch;
                },
            },
            .instance => |instance| switch (expected) {
                .instance => |expected_i| {
                    if (instance.class_id != expected_i.class_id) {
                        return error.TypeMismatch;
                    }
                    if (instance.args.len != expected_i.args.len) {
                        return error.TypeMismatch;
                    }
                    for (instance.args, expected_i.args) |actual_arg, expected_arg| {
                        try unify(actual_arg, expected_arg, bindings, program, alloc);
                    }
                },
                .any => {},
                else => {
                    const lhs = try self.toDisplayName(program, alloc);
                    defer alloc.free(lhs);
                    const rhs = try expected.toDisplayName(program, alloc);
                    defer alloc.free(rhs);
                    std.debug.print("cant unify {s} with {s}\n", .{ lhs, rhs });
                    return error.TypeMistmatch;
                },
            },
            .tuple => |tuple| switch (expected) {
                .tuple => |expected_t| {
                    if (tuple.elements.len != expected_t.elements.len) {
                        return error.TypeMismatch;
                    }
                    for (tuple.elements, expected_t.elements) |t, e| {
                        try unify(t, e, bindings, program, alloc);
                    }
                },
                else => {
                    const lhs = try self.toString(alloc);
                    defer alloc.free(lhs);
                    const rhs = try expected.toString(alloc);
                    defer alloc.free(rhs);
                    std.debug.print("cant unify {s} with {s}\n", .{ lhs, rhs });
                    return error.TypeMistmatch;
                },
            },
            .callable => |callable| switch (expected) {
                .callable => |expected_c| {
                    if (callable.params.len != expected_c.params.len) {
                        return error.TypeMismatch;
                    }
                    for (callable.params, expected_c.params) |param, expected_param| {
                        try param.unify(expected_param, bindings, program, alloc);
                    }
                    try callable.returns.*.unify(expected_c.returns.*, bindings, program, alloc);
                },
                else => {
                    const lhs = try self.toString(alloc);
                    defer alloc.free(lhs);
                    const rhs = try expected.toString(alloc);
                    defer alloc.free(rhs);
                    std.debug.print("cant unify {s} with {s}\n", .{ lhs, rhs });
                    return error.TypeMistmatch;
                },
            },
            else => {
                // FIXME: enabling this causing tons of type errors between i64 and i32
                // need better type propogation to enable this
                // if (!self.equal(expected)) {
                //     const self_type = try self.toString(alloc);
                //     defer alloc.free(self_type);
                //     const expected_type = try expected.toString(alloc);
                //     defer alloc.free(expected_type);
                //     std.debug.print("expected type {s} got {s}\n", .{ self_type, expected_type });
                //     return error.TypeMismatch;
                // }
            },
        }
    }

    /// returns generics evaluate type
    pub fn substitute(self: @This(), bindings: *TypeBindings, alloc: std.mem.Allocator) !TypeInfo {
        switch (self) {
            .type_variable => |t| {
                const actual = bindings.get(t) orelse {
                    return error.ExpectedBinding;
                };
                return try actual.clone(alloc);
            },
            .array => |a| {
                const elem = try substitute(a.element.*, bindings, alloc);
                return .{ .array = .{ .element = try elem.toOwnedPointer(alloc) } };
            },
            // substitutes fields not methods
            .instance => |i| {
                var args = try alloc.alloc(TypeInfo, i.args.len);
                var initialized: usize = 0;
                errdefer {
                    for (args[0..initialized]) |arg| {
                        arg.deinit(alloc);
                    }
                    alloc.free(args);
                }
                for (i.args, 0..) |arg, arg_i| {
                    args[arg_i] = try arg.substitute(bindings, alloc);
                    initialized += 1;
                }

                return .{ .instance = .{
                    .class_id = i.class_id,
                    .args = args,
                } };
            },
            else => return try self.clone(alloc),
        }
    }

    pub fn containsGenericVariable(self: @This(), wanted: ?TypeVarId) bool {
        return switch (self) {
            .type_variable => |found| if (wanted) |w| found == w else true,
            .array => |a| a.element.containsGenericVariable(wanted),
            .tuple => |t| {
                for (t.elements) |elem| {
                    if (elem.containsGenericVariable(wanted)) return true;
                }
                return false;
            },
            .i64, .i32, .f64, .f32, .char, .bool => false,
            .callable => |c| {
                for (c.params) |param| {
                    if (param.containsGenericVariable(wanted)) return true;
                }
                return c.returns.*.containsGenericVariable(wanted);
            },
            .instance => |i| {
                for (i.args) |arg| {
                    if (arg.containsGenericVariable(wanted)) return true;
                }
                return false;
            },
            .@"enum" => false,
            else => |e| {
                std.debug.print("cant handle {s}\n", .{@tagName(e)});
                unreachable;
            },
        };
    }

    pub fn toString(self: @This(), alloc: std.mem.Allocator) ![]const u8 {
        return switch (self) {
            .i64 => try alloc.dupe(u8, "i64"),
            .i32 => try alloc.dupe(u8, "i32"),
            .bool => try alloc.dupe(u8, "bool"),
            .char => try alloc.dupe(u8, "char"),
            .f64 => try alloc.dupe(u8, "f64"),
            .f32 => try alloc.dupe(u8, "f32"),
            .module => try alloc.dupe(u8, "module"),
            .any => try alloc.dupe(u8, "any"),
            .void => try alloc.dupe(u8, "void"),
            .@"enum" => try alloc.dupe(u8, "enum"),
            .tuple => |t| blk: {
                var out: std.ArrayList(u8) = .empty;
                errdefer out.deinit(alloc);
                try out.append(alloc, '(');
                for (t.elements, 0..) |elem, i| {
                    const elem_string = try elem.toString(alloc);
                    defer alloc.free(elem_string);
                    if (i != 0) try out.appendSlice(alloc, ", ");
                    try out.appendSlice(alloc, elem_string);
                }
                try out.append(alloc, ')');
                break :blk try out.toOwnedSlice(alloc);
            },
            .array => |a| blk: {
                const elem = try a.element.*.toString(alloc);
                defer alloc.free(elem);

                break :blk try std.fmt.allocPrint(alloc, "array_{s}", .{elem});
            },
            .lazy => |l| blk: {
                const elem = try l.value.*.toString(alloc);
                defer alloc.free(elem);

                break :blk try std.fmt.allocPrint(alloc, "lazy_{s}", .{elem});
            },
            .iterable => |i| blk: {
                const elem = try i.element.*.toString(alloc);
                defer alloc.free(elem);

                break :blk try std.fmt.allocPrint(alloc, "iterable_{s}", .{elem});
            },
            .callable => |c| blk: {
                var out: std.ArrayList(u8) = .empty;
                errdefer out.deinit(alloc);
                try out.append(alloc, '(');
                for (c.params, 0..) |param, i| {
                    const param_string = try param.toString(alloc);
                    defer alloc.free(param_string);
                    try out.appendSlice(alloc, param_string);
                    if (i == 0) try out.appendSlice(alloc, ", ");
                }
                try out.appendSlice(alloc, ") -> ");
                const return_string = try c.returns.toString(alloc);
                defer alloc.free(return_string);
                try out.appendSlice(alloc, return_string);
                break :blk try out.toOwnedSlice(alloc);
            },
            .type_variable => |tv| try std.fmt.allocPrint(alloc, "T{d}", .{tv}),
            .instance => |instance| blk: {
                var out: std.ArrayList(u8) = .empty;
                errdefer out.deinit(alloc);
                try out.appendSlice(alloc, "class_");
                const class_id = try std.fmt.allocPrint(alloc, "{d}", .{instance.class_id});
                defer alloc.free(class_id);
                try out.appendSlice(alloc, class_id);
                if (instance.args.len > 0) {
                    try out.appendSlice(alloc, "_");
                    for (instance.args) |arg| {
                        const arg_name = try arg.toString(alloc);
                        defer alloc.free(arg_name);
                        try out.appendSlice(alloc, arg_name);
                    }
                }
                break :blk out.toOwnedSlice(alloc);
            },
            else => |e| {
                std.debug.print("cannot stringify type {s}\n", .{@tagName(e)});
                return error.TypeStringNotImpl;
            },
        };
    }

    pub fn toDisplayName(self: @This(), program: *const Program, alloc: std.mem.Allocator) ![]const u8 {
        switch (self) {
            .array => |a| {
                const elem = try a.element.*.toDisplayName(program, alloc);
                defer alloc.free(elem);

                return try std.fmt.allocPrint(alloc, "array[{s}]", .{elem});
            },
            .instance => |instance| {
                const class = program.classes.items[instance.class_id];
                var out: std.ArrayList(u8) = .empty;
                errdefer out.deinit(alloc);
                try out.appendSlice(alloc, class.name);
                if (instance.args.len > 0) {
                    try out.append(alloc, '[');
                    for (instance.args, 0..) |arg, i| {
                        if (i != 0) try out.appendSlice(alloc, ", ");
                        const name = try arg.toDisplayName(program, alloc);
                        defer alloc.free(name);
                        try out.appendSlice(alloc, name);
                    }
                    try out.append(alloc, ']');
                }
                return out.toOwnedSlice(alloc);
            },
            else => return try self.toString(alloc),
        }
    }
};

test "unify + sub" {}
