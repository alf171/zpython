const std = @import("std");
const ArrayList = std.ArrayList;
const ModuleId = @import("module.zig").ModuleId;
const TypeVarId = @import("types.zig").TypeVarId;
const TypeInfo = @import("types.zig").TypeInfo;
const TypeBindings = @import("types.zig").TypeBindings;
const ConstValue = @import("ir.zig").ConstValue;
const ValueRef = @import("ir.zig").ValueRef;
const BasicBlock = @import("ir.zig").BasicBlock;
const BlockId = @import("ir.zig").BlockId;
const Operand = @import("alloc.zig").Operand;

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
        const label = if (std.mem.eql(u8, func_name, "main"))
            try alloc.dupe(u8, "main")
        else
            try std.fmt.allocPrint(alloc, "_{s}__{s}", .{ module_name, func_name });

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
