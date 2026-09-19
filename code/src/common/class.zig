const std = @import("std");
const ArrayList = std.ArrayList;
const TypeParam = @import("function.zig").TypeParam;
const TypeInfo = @import("types.zig").TypeInfo;
const TypeBindings = @import("types.zig").TypeBindings;
const ClassInstance = @import("types.zig").ClassInstance;
const Program = @import("program.zig").Program;
// classes hold methods and fields
pub const ClassId = u32;

pub const Field = struct {
    name: []const u8,
    type: TypeInfo,
};

pub const Method = struct {
    name: []const u8,
    function_label: []const u8,
    function_id: usize,
    is_static: bool,

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        alloc.free(self.name);
        alloc.free(self.function_label);
    }

    pub fn clone(self: @This(), alloc: std.mem.Allocator) !@This() {
        return .{
            .name = try alloc.dupe(u8, self.name),
            .function_label = try alloc.dupe(u8, self.function_label),
            .function_id = self.function_id,
            .is_static = self.is_static,
        };
    }
};

pub const ClassInfo = struct {
    id: ClassId,
    name: []const u8,
    type_params: []TypeParam,
    fields: ArrayList(Field),
    methods: ArrayList(Method),
    base_class: ?ClassId,
    // if class was derrived from specialization
    template_id: ?ClassId = null,

    pub fn init(id: ClassId, name: []const u8, type_params: []TypeParam, base_class: ?ClassId, alloc: std.mem.Allocator) !@This() {
        return .{
            .id = id,
            .name = try alloc.dupe(u8, name),
            .type_params = type_params,
            .fields = .empty,
            .methods = .empty,
            .base_class = base_class,
        };
    }

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        alloc.free(self.name);
        for (self.type_params) |*type_param| {
            type_param.deinit(alloc);
        }
        alloc.free(self.type_params);
        for (self.fields.items) |*field| {
            alloc.free(field.name);
            field.type.deinit(alloc);
        }
        self.fields.deinit(alloc);
        for (self.methods.items) |*method| {
            method.deinit(alloc);
        }
        self.methods.deinit(alloc);
    }

    // O(n) scan for field
    pub fn findField(self: *@This(), name: []const u8) ?*Field {
        for (self.fields.items) |*field| {
            if (std.mem.eql(u8, field.name, name)) {
                return field;
            }
        }
        return null;
    }

    pub fn findFieldIdx(self: *const @This(), name: []const u8) ?usize {
        for (self.fields.items, 0..) |field, i| {
            if (std.mem.eql(u8, field.name, name)) {
                return i;
            }
        }
        return null;
    }

    // O(n) scan for method
    pub fn findMethod(self: *@This(), name: []const u8) ?*Method {
        for (self.methods.items) |*method| {
            if (std.mem.eql(u8, method.name, name)) {
                return method;
            }
        }
        return null;
    }

    pub fn specialize(
        self: *const @This(),
        specialized_name: []const u8,
        specialized_id: ClassId,
        bindings: *TypeBindings,
        alloc: std.mem.Allocator,
    ) !@This() {
        var res = try init(
            specialized_id,
            specialized_name,
            try alloc.alloc(TypeParam, 0),
            self.base_class,
            alloc,
        );
        errdefer res.deinit(alloc);

        res.template_id = self.id;
        for (self.fields.items) |field| {
            const field_type = try field.type.substitute(bindings, alloc);
            errdefer field_type.deinit(alloc);
            try res.fields.append(alloc, .{
                .name = try alloc.dupe(u8, field.name),
                .type = field_type,
            });
        }
        for (self.methods.items) |method| {
            try res.methods.append(alloc, try method.clone(alloc));
        }
        return res;
    }

    pub fn resolveFieldType(
        self: *const @This(),
        field: *const Field,
        instance: ClassInstance,
        alloc: std.mem.Allocator,
    ) !TypeInfo {
        if (self.type_params.len == 0) {
            return try field.type.clone(alloc);
        }

        if (self.type_params.len != instance.args.len) {
            return error.InvalidTypeArgCount;
        }

        var bindings: TypeBindings = .init(alloc);
        defer bindings.deinit(alloc);
        for (self.type_params, instance.args) |type_param, arg| {
            const owned_arg = try arg.clone(alloc);
            errdefer owned_arg.deinit(alloc);
            try bindings.put(type_param.id, owned_arg);
        }

        return field.type.substitute(&bindings, alloc);
    }

    pub fn resolveOffset(
        self: *const @This(),
        instance: ClassInstance,
        field_index: usize,
        program: *const Program,
        alloc: std.mem.Allocator,
    ) !usize {
        var offset: usize = 0;
        if (self.base_class) |base_id| {
            const base = &program.classes.items[base_id];
            if (base.type_params.len != 0) {
                return error.GenericInheritanceNotSupported;
            }
            offset = try base.resolveOffset(
                .{ .class_id = base_id, .args = &.{} },
                base.fields.items.len,
                program,
                alloc,
            );
        }
        for (self.fields.items[0..field_index]) |*field| {
            const field_type = try self.resolveFieldType(field, instance, alloc);
            defer field_type.deinit(alloc);
            offset += try field_type.sizeOfType();
        }
        return offset;
    }
};
