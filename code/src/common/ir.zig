const std = @import("std");
const Instruction = @import("mir.zig").Instruction;
const ArrayList = std.ArrayList;
const Program = @import("program.zig").Program;
const ClassInstance = @import("types.zig").ClassInstance;
const TypeBindings = @import("types.zig").TypeBindings;
const TypeInfo = @import("types.zig").TypeInfo;
const TypeVarId = @import("types.zig").TypeVarId;
const TypedOperand = @import("alloc.zig").TypedOperand;
const Operand = @import("alloc.zig").Operand;
const RegisterType = @import("register.zig").RegisterType;
const RegisterClass = @import("register.zig").RegisterClass;
const ModuleId = @import("module.zig").ModuleId;

pub const ParsedConstant = union(enum) {
    immediate: ConstValue,
    composite: struct {
        elements: []ValueRef,
        type: TypeInfo,
    },

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        switch (self.*) {
            .immediate => return,
            .composite => |comp| {
                alloc.free(comp.elements);
                comp.type.deinit(alloc);
            },
        }
    }

    pub fn toType(self: @This()) TypeInfo {
        switch (self) {
            .immediate => |imm| return imm.toType(),
            .composite => |comp| return comp.type,
        }
    }

    pub fn clone(self: *const @This(), alloc: std.mem.Allocator) !@This() {
        return switch (self.*) {
            .immediate => |imm| .{ .immediate = imm },
            .composite => |comp| blk: {
                var elements = try alloc.alloc(ValueRef, comp.elements.len);
                errdefer alloc.free(elements);
                for (comp.elements, 0..) |elem, i| {
                    elements[i] = try elem.clone(alloc);
                }
                break :blk .{ .composite = .{ .elements = elements, .type = try comp.type.clone(alloc) } };
            },
        };
    }
};

pub const SeenValuePtr = union(enum) {
    top: *TypedOperand,
    local: *LocalId,

    pub fn value(self: @This()) SeenValue {
        return switch (self) {
            .top => |top| .{ .top = top.* },
            .local => |local| .{ .local = local.* },
        };
    }
};

pub const SeenValue = union(enum) {
    top: TypedOperand,
    local: LocalId,
};

pub const PhysicalReg = struct {
    id: u8,
    type: RegisterType,
    width: u8,

    pub fn equal(self: @This(), other: @This()) bool {
        return self.id == other.id and self.type == other.type and self.width == other.width;
    }
};

pub const BlockId = u32;
// python defined variable
pub const LocalId = u32;
pub const LocalInfo = struct {
    id: LocalId,
    name: []const u8,
    type: TypeInfo,

    pub fn clone(self: @This(), alloc: std.mem.Allocator) !@This() {
        return .{
            .id = self.id,
            .name = try alloc.dupe(u8, self.name),
            .type = try self.type.clone(alloc),
        };
    }
};

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

// classes hold methods and fields
pub const ClassId = u32;

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

// compiler defined variable
pub const TempId = u16;

/// we only permit 255 spills per program
pub const MemoryId = u8;

pub const FunctionType = enum {
    runtime,
    user,
};

pub const FunctionKind = enum {
    host,
    gpu_kernel,
};

pub const BinOp = enum {
    add,
    sub,
    mul,
    div,
    floor_div,
    mod,
    lshift,
    rshift,
    matmul,
    unknown,

    pub fn toClassBuiltin(self: @This()) ![]const u8 {
        return switch (self) {
            .add => "__add__",
            .sub => "__sub__",
            .mul => "__mul__",
            .matmul => "__matmul__",
            .div => "__truediv__",
            else => return error.CantFindBuiltin,
        };
    }

    pub fn isCommutative(self: @This()) bool {
        return switch (self) {
            .add, .mul => true,
            .sub, .div, .floor_div, .mod, .lshift, .rshift, .matmul => false,
            else => unreachable,
        };
    }
};

pub const UnaryOp = enum { neg, exp2 };

pub const ConstValue = union(enum) {
    i64: i64,
    i32: i32,
    bool: bool,
    f64: f64,
    f32: f32,
    char: u8,

    pub fn print(self: @This()) void {
        switch (self) {
            .i64, .i32 => |i| std.debug.print("{d}", .{i}),
            .bool => |b| std.debug.print("{}", .{b}),
            .f64, .f32 => |f| std.debug.print("{}", .{f}),
            .char => |c| std.debug.print("{}", .{c}),
        }
    }

    /// return size in bytes
    pub fn size(self: @This()) usize {
        return switch (self) {
            .float, .i64 => 8,
            .i32 => 4,
            .bool, .char => 1,
        };
    }

    pub fn toType(self: @This()) TypeInfo {
        return switch (self) {
            .i64 => .i64,
            .i32 => .i32,
            .bool => .bool,
            .f64 => .f64,
            .f32 => .f32,
            .char => .char,
        };
    }

    pub fn valueAsIntImm(self: @This()) !i64 {
        return switch (self) {
            .i64 => |v| v,
            .i32 => |v| @intCast(v),
            .bool => |v| @intFromBool(v),
            .char => |v| @intCast(v),
            .f64, .f32 => return error.BadState,
        };
    }

    pub fn isZero(self: @This()) bool {
        return switch (self) {
            .i64 => |i| i == 0,
            .i32 => |i| i == 0,
            .f64 => |f| f == 0.0,
            .f32 => |f| f == 0.0,
            .bool => |b| !b,
            .char => |c| c == 0,
        };
    }
    pub fn isOne(self: @This()) bool {
        return switch (self) {
            .i64 => |i| i == 1,
            .i32 => |i| i == 1,
            .f64 => |f| f == 1.0,
            .f32 => |f| f == 1.0,
            .bool => |b| b,
            .char => |c| c == 1,
        };
    }

    pub fn coherce(self: @This(), expected_type: ?TypeInfo) !@This() {
        const t = expected_type orelse return self;
        if (t.containsGenericVariable()) return self;
        return switch (self) {
            .i64 => |value| switch (t) {
                .i64 => self,
                .i32 => .{ .i32 = @intCast(value) },
                .f64 => .{ .f64 = @floatFromInt(value) },
                .f32 => .{ .f32 = @floatFromInt(value) },
                else => return error.InvalidConstantCohersion,
            },
            .f64 => |value| switch (t) {
                .f64 => self,
                .f32 => .{ .f32 = @floatCast(value) },
                else => return error.InvalidConstantCohersion,
            },
            else => return self,
        };
    }
};

pub const ValueRef = union(enum) {
    top: TypedOperand,
    constant: ConstValue,

    pub fn toType(self: @This(), alloc: std.mem.Allocator) !TypeInfo {
        return switch (self) {
            .constant => |c| c.toType(),
            .top => |top| try top.type.clone(alloc),
        };
    }

    pub fn print(self: @This()) void {
        switch (self) {
            .top => |top| top.operand.print(),
            .constant => |c| c.print(),
        }
    }

    pub fn clone(self: *const @This(), alloc: std.mem.Allocator) !@This() {
        return switch (self.*) {
            .constant => |constant| .{ .constant = constant },
            .top => |top| .{ .top = try top.clone(alloc) },
        };
    }

    pub fn deinit(self: @This(), alloc: std.mem.Allocator) void {
        switch (self) {
            .top => |top| top.type.deinit(alloc),
            .constant => {},
        }
    }
};

pub const CmpOp = enum {
    eq,
    neq,
    lt,
    lte,
    gt,
    gte,

    pub fn symbol(self: @This()) []const u8 {
        return switch (self) {
            .eq => "==",
            .neq => "!=",
            .lt => "<",
            .lte => "<=",
            .gt => ">",
            .gte => ">=",
        };
    }

    pub fn condForCmp(op: @This()) []const u8 {
        return switch (op) {
            .eq => "eq",
            .neq => "ne",
            .lt => "lt",
            .lte => "le",
            .gt => "gt",
            .gte => "ge",
        };
    }
};

pub const BasicBlock = struct {
    id: BlockId,
    instructions: ArrayList(Instruction),
    // [fn A: block 0] [fn A: block 1] [fn B: block 0]...
    predecessors: ArrayList(BlockId),
    successors: ArrayList(BlockId),

    pub fn init(id: BlockId) BasicBlock {
        return .{
            .id = id,
            .instructions = .empty,
            .predecessors = .empty,
            .successors = .empty,
        };
    }

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        for (self.instructions.items) |*instruction| {
            instruction.deinit(alloc);
        }
        self.instructions.deinit(alloc);
        self.predecessors.deinit(alloc);
        self.successors.deinit(alloc);
    }
};

/// a function parameter its type and potentially a default value
pub const Param = struct {
    name: []const u8,
    type: TypeInfo,
    default: ?ParsedConstant = null,

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        alloc.free(self.name);
        self.type.deinit(alloc);
        if (self.default) |*def| {
            def.deinit(alloc);
        }
    }
};

pub const TypeParam = struct {
    name: []const u8,
    id: TypeVarId,

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        alloc.free(self.name);
    }

    pub fn clone(self: *@This(), alloc: std.mem.Allocator) !@This() {
        return .{
            .name = try alloc.dupe(u8, self.name),
            .id = self.id,
        };
    }
};

pub const Function = struct {
    // function name
    name: []const u8,
    // asm label (`module_name`__`name`)
    label: []const u8,
    id: usize,
    module_id: ModuleId,
    module_name: []const u8,
    params: []Param,
    type_params: []TypeParam,
    return_type: TypeInfo,
    blocks: ArrayList(BasicBlock),
    entry_block: BlockId,
    next_temp: TempId,
    next_mem: MemoryId,
    origin: FunctionType,
    kind: FunctionKind,
    is_inline: bool,
    value_to_type: std.AutoHashMap(Operand, TypeInfo),

    pub fn nextTemp(self: *@This()) Operand {
        const id = self.next_temp;
        self.next_temp += 1;
        return Operand{ .temp = .{
            .id = id,
            .function_id = self.id,
        } };
    }

    pub fn nextMem(self: *@This()) Operand {
        const id = self.next_mem;
        self.next_mem += 1;
        return Operand{ .mem = .{
            .id = id,
            .function_id = self.id,
        } };
    }

    pub fn init(
        func_name: []const u8,
        id: usize,
        module_id: ModuleId,
        module_name: []const u8,
        params: []Param,
        type_params: []TypeParam,
        return_type: TypeInfo,
        origin: FunctionType,
        kind: FunctionKind,
        is_inline: bool,
        alloc: std.mem.Allocator,
    ) !@This() {
        var blocks = ArrayList(BasicBlock).empty;
        try blocks.append(alloc, BasicBlock.init(0));

        const name = try alloc.dupe(u8, func_name);
        const label = if (std.mem.eql(u8, func_name, "main")) blk: {
            break :blk try alloc.dupe(u8, "main");
        } else if (origin == .user) blk: {
            break :blk try std.fmt.allocPrint(alloc, "_{s}__{s}", .{ module_name, func_name });
        } else try alloc.dupe(u8, func_name);

        return .{
            .name = name,
            .label = label,
            .id = id,
            .module_id = module_id,
            .module_name = try alloc.dupe(u8, module_name),
            .params = params,
            .type_params = type_params,
            .return_type = return_type,
            .blocks = blocks,
            .entry_block = 0,
            .next_temp = 0,
            .next_mem = 0,
            .origin = origin,
            .kind = kind,
            .is_inline = is_inline,
            .value_to_type = std.AutoHashMap(Operand, TypeInfo).init(alloc),
        };
    }

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        for (self.blocks.items) |*block| {
            block.deinit(alloc);
        }
        self.blocks.deinit(alloc);
        // function metadata
        self.return_type.deinit(alloc);
        alloc.free(self.name);
        for (self.params) |*param| {
            param.deinit(alloc);
        }
        alloc.free(self.params);
        for (self.type_params) |*t_param| {
            t_param.deinit(alloc);
        }
        alloc.free(self.type_params);
        var it = self.value_to_type.valueIterator();
        while (it.next()) |t| {
            t.deinit(alloc);
        }
        self.value_to_type.deinit();
        // free module stuff
        alloc.free(self.label);
        alloc.free(self.module_name);
    }

    pub fn setValueType(self: *@This(), operand: Operand, type_info: TypeInfo, alloc: std.mem.Allocator) !void {
        if (self.value_to_type.getPtr(operand)) |existing| {
            existing.deinit(alloc);
            existing.* = try type_info.clone(alloc);
            return;
        }

        try self.value_to_type.put(operand, try type_info.clone(alloc));
    }

    pub fn findTypeParam(self: *const @This(), name: []const u8) ?TypeParam {
        for (self.type_params) |type_param| {
            if (std.mem.eql(u8, type_param.name, name)) {
                return type_param;
            }
        }
        return null;
    }

    /// clones a generic function applying type bindings
    pub fn specialize(
        function: *const @This(),
        specialized_name: []const u8,
        specialized_id: usize,
        bindings: *TypeBindings,
        alloc: std.mem.Allocator,
    ) !@This() {
        var params = try alloc.alloc(Param, function.params.len);
        errdefer alloc.free(params);

        for (function.params, 0..) |param, i| {
            params[i] = .{
                .name = try alloc.dupe(u8, param.name),
                .type = try param.type.substitute(bindings, alloc),
                .default = if (param.default) |d| try d.clone(alloc) else null,
            };
        }

        const return_type = try function.return_type.substitute(bindings, alloc);

        var cloned = try Function.init(
            specialized_name,
            specialized_id,
            function.module_id,
            function.module_name,
            params,
            try alloc.alloc(TypeParam, 0),
            return_type,
            function.origin,
            function.kind,
            function.is_inline,
            alloc,
        );
        errdefer cloned.deinit(alloc);

        // deinit init'd stuff
        cloned.blocks.items[0].deinit(alloc);
        cloned.blocks.clearRetainingCapacity();

        for (function.blocks.items) |source| {
            var block = BasicBlock.init(source.id);
            errdefer block.deinit(alloc);
            try block.predecessors.appendSlice(alloc, source.predecessors.items);
            try block.successors.appendSlice(alloc, source.successors.items);

            for (source.instructions.items) |*source_instruct| {
                var instruct = try source_instruct.clone(alloc);
                errdefer instruct.deinit(alloc);
                try instruct.remapInstruction(specialized_id, bindings, alloc);
                try block.instructions.append(alloc, instruct);
            }
            try cloned.blocks.append(alloc, block);
        }

        cloned.entry_block = function.entry_block;
        cloned.next_temp = function.next_temp;
        cloned.next_mem = function.next_mem;

        return cloned;
    }
};
