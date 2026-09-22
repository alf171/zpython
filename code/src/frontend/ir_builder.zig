const std = @import("std");
const ArrayList = std.ArrayList;

const BlockId = @import("common").ir.BlockId;
const LocalId = @import("common").ir.LocalId;
const ClassId = @import("common").class.ClassId;
const ClassInfo = @import("common").class.ClassInfo;
const LocalInfo = @import("common").ir.LocalInfo;
const TempId = @import("common").function.TempId;
const Function = @import("common").function.Function;
const FunctionType = @import("common").function.FunctionType;
const TypeInfo = @import("common").types.TypeInfo;
const TypeParam = @import("common").function.TypeParam;

const BasicBlock = @import("common").ir.BasicBlock;
const Operand = @import("common").alloc.Operand;
const TypedOperand = @import("common").alloc.TypedOperand;
const Program = @import("common").program.Program;
const Instruction = @import("common").mir.Instruction;

const ImportEdge = @import("module.zig").ImportEdge;
const ModuleId = @import("common").module.ModuleId;
const ImportFunction = @import("common").module.ImportFunction;

pub const LocalValues = struct {
    map: std.AutoHashMap(LocalId, TypedOperand),

    pub fn init(alloc: std.mem.Allocator) @This() {
        return .{ .map = .init(alloc) };
    }

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        var it = self.map.valueIterator();
        while (it.next()) |value| {
            value.deinit(alloc);
        }
        self.map.deinit();
    }

    pub fn clone(self: *@This(), alloc: std.mem.Allocator) !LocalValues {
        var cloned: LocalValues = .init(alloc);
        errdefer cloned.deinit(alloc);

        var it = self.map.iterator();
        while (it.next()) |entry| {
            const value = try entry.value_ptr.*.clone(alloc);
            cloned.map.put(entry.key_ptr.*, value) catch |err| {
                value.deinit(alloc);
                return err;
            };
        }

        return cloned;
    }

    pub fn clear(self: *@This(), alloc: std.mem.Allocator) void {
        var it = self.map.valueIterator();
        while (it.next()) |entry| {
            entry.deinit(alloc);
        }
        self.map.clearRetainingCapacity();
    }
};

pub const LocalScope = struct {
    // name -> LocalId
    locals_by_name: std.StringHashMap(LocalId),
    // LocalId -> TypedOperand
    local_values: LocalValues,
    // LocalId -> LocalValues
    locals: ArrayList(LocalInfo),

    pub fn init(alloc: std.mem.Allocator) @This() {
        return .{
            .locals_by_name = .init(alloc),
            .local_values = .init(alloc),
            .locals = .empty,
        };
    }

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        {
            var it = self.locals_by_name.keyIterator();
            while (it.next()) |key| {
                alloc.free(key.*);
            }
            self.locals_by_name.deinit();
        }
        self.local_values.deinit(alloc);
        for (self.locals.items) |local| {
            local.type.deinit(alloc);
            alloc.free(local.name);
        }
        self.locals.deinit(alloc);
    }

    pub fn restoreLocalValues(self: *@This(), locals: *const LocalValues, alloc: std.mem.Allocator) !void {
        self.local_values.clear(alloc);

        var it = locals.map.iterator();
        while (it.next()) |entry| {
            const value = try entry.value_ptr.*.clone(alloc);
            self.local_values.map.put(entry.key_ptr.*, value) catch |err| {
                value.deinit(alloc);
                return err;
            };
        }
    }

    pub fn putLocalValues(self: *@This(), local: LocalId, value: TypedOperand, alloc: std.mem.Allocator) !void {
        if (try self.local_values.map.fetchPut(local, value)) |previous| {
            previous.value.deinit(alloc);
        }
    }

    pub fn getOrCreateLocal(self: *@This(), name: []const u8, typeInfo: ?TypeInfo, alloc: std.mem.Allocator) !LocalId {
        // already existed
        if (self.locals_by_name.get(name)) |local| {
            return local;
        }
        // needs to get created
        const id: LocalId = @intCast(self.locals.items.len);
        try self.locals_by_name.put(try alloc.dupe(u8, name), id);
        try self.locals.append(alloc, .{
            .id = id,
            .name = try alloc.dupe(u8, name),
            .type = if (typeInfo) |t|
                try t.clone(alloc)
            else
                .any,
        });
        return id;
    }
};

pub const FunctionContext = struct {
    function: ?usize,
    block: BlockId,
    scope: LocalScope,
    active_param_types: []const TypeParam,
};

pub const IrBuilder = struct {
    program: Program,
    current_block: BlockId,
    current_function: ?usize,
    current_class: ?ClassId,
    // TODO: support closure
    current_scope: LocalScope,
    function_origin: FunctionType,
    active_param_types: []const TypeParam,
    // imports metadata
    current_imports: []const ImportEdge,
    current_module_id: ModuleId,
    current_module_name: []const u8,

    pub fn init(origin: FunctionType, module_id: ModuleId, module_name: []const u8, alloc: std.mem.Allocator) !IrBuilder {
        const program = try Program.init(module_id, module_name, alloc);

        return .{
            .program = program,
            .current_function = null,
            .current_block = 0,
            .current_class = null,
            .current_scope = .init(alloc),
            .function_origin = origin,
            .active_param_types = &.{},
            .current_imports = &.{},
            .current_module_id = module_id,
            .current_module_name = module_name,
        };
    }

    /// free all but the generated program
    pub fn deinit(self: *IrBuilder, alloc: std.mem.Allocator) void {
        self.current_scope.deinit(alloc);
    }

    pub fn currentBlocks(self: *@This()) *ArrayList(BasicBlock) {
        const function = self.currentFunction();
        return &function.blocks;
    }

    pub fn currentBlock(self: *@This()) *BasicBlock {
        const blocks = currentBlocks(self);
        return &blocks.items[self.current_block];
    }

    pub fn currentFunction(self: *@This()) *Function {
        if (self.current_function) |i| {
            return &self.program.functions.items[i];
        }
        return &self.program.main;
    }

    pub fn nextTemp(self: *@This()) Operand {
        const function = self.currentFunction();
        return function.nextTemp();
    }

    pub fn nextFunctionId(self: *@This()) usize {
        return self.program.functions.items.len + 1;
    }

    pub fn nextClassIdx(self: *@This()) ClassId {
        return @intCast(self.program.classes.items.len);
    }

    /// O(function) scan looking for matching name
    /// careful because this is not module aware!
    pub fn findFunction(self: *@This(), name: []const u8) ?*Function {
        return self.program.findFunction(name);
    }

    /// get function from index
    pub fn getFunction(self: *@This(), id: usize) ?*Function {
        if (id == 0 or id > self.program.functions.items.len) return null;
        return &self.program.functions.items[id - 1];
    }

    /// get class from index
    pub fn getClass(self: *@This(), class_id: ClassId) *ClassInfo {
        return &self.program.classes.items[class_id];
    }

    /// O(class) scan looking for matching name
    pub fn findClass(self: *@This(), name: []const u8) ?*ClassInfo {
        for (self.program.classes.items) |*class| {
            if (std.mem.eql(u8, class.name, name)) {
                return class;
            }
        }
        return null;
    }

    pub fn getLocal(self: *@This(), name: []const u8) !LocalId {
        if (self.current_scope.locals_by_name.get(name)) |local| {
            return local;
        }
        return error.CantFindLocal;
    }

    pub fn emit(self: *@This(), instruct: Instruction, alloc: std.mem.Allocator) !void {
        const function = self.currentFunction();
        if (instruct.getDefines()) |defines| {
            switch (defines) {
                .top => |top| try function.setValueType(top.operand, top.type, alloc),
                .local => {},
            }
        }
        try self.currentBlocks().items[self.current_block].instructions.append(alloc, instruct);
    }

    pub fn newBlock(self: *@This(), alloc: std.mem.Allocator) !BlockId {
        const blocks = self.currentBlocks();
        const id: BlockId = @intCast(blocks.items.len);
        const new_block = BasicBlock.init(id);

        try blocks.append(alloc, new_block);
        return id;
    }

    pub fn setCurrentBlock(self: *@This(), id: BlockId) void {
        self.current_block = id;
    }

    pub fn addSuccessor(self: *@This(), from: BlockId, to: BlockId, alloc: std.mem.Allocator) !void {
        const current_block = self.currentBlocks();
        try current_block.items[to].predecessors.append(alloc, from);
        try current_block.items[from].successors.append(alloc, to);
    }

    /// fetch the current functions type_param by its name
    pub fn getActiveParmType(self: *@This(), name: []const u8) ?TypeParam {
        for (self.active_param_types) |type_param| {
            if (std.mem.eql(u8, type_param.name, name)) {
                return type_param;
            }
        }
        return null;
    }

    pub fn findImportModule(self: *const @This(), name: []const u8) ?ModuleId {
        for (self.current_imports) |import| {
            switch (import) {
                .module => |module| {
                    if (std.mem.eql(u8, module.name, name)) {
                        return module.id;
                    }
                },
                .function => {},
            }
        }
        return null;
    }

    pub fn findImportedFunction(self: *const @This(), name: []const u8) ?ImportFunction {
        for (self.current_imports) |import| {
            switch (import) {
                .function => |func| {
                    const resolved_name = func.alias orelse func.function_name;
                    if (std.mem.eql(u8, resolved_name, name)) {
                        return func;
                    }
                },
                .module => {},
            }
        }
        return null;
    }

    pub fn getModuleFunction(self: *const @This(), id: ModuleId, name: []const u8) ?*Function {
        for (self.program.functions.items) |*function| {
            if (function.module_id != id) continue;

            if (std.mem.eql(u8, function.name, name)) {
                return function;
            }
        }
        return null;
    }

    /// save current function state and change to new
    pub fn enterFunction(self: *@This(), function_id: usize, new_scope: LocalScope) FunctionContext {
        const saved: FunctionContext = .{
            .function = self.current_function,
            .block = self.current_block,
            .scope = self.current_scope,
            .active_param_types = self.active_param_types,
        };
        self.current_function = function_id;
        self.current_block = 0;
        self.current_scope = new_scope;
        self.active_param_types = self.currentFunction().type_params;
        return saved;
    }

    /// restore function state
    pub fn leaveFunction(self: *@This(), context: FunctionContext, alloc: std.mem.Allocator) void {
        self.current_function = context.function;
        self.current_block = context.block;
        self.current_scope.deinit(alloc);
        self.current_scope = context.scope;
        self.active_param_types = context.active_param_types;
    }
};

test "create ir builder" {
    const alloc = std.testing.allocator;
    var irBuilder = try IrBuilder.init(.user, 0, "__init__", alloc);
    defer irBuilder.deinit(alloc);
    defer irBuilder.program.deinit(alloc);

    const block = try irBuilder.newBlock(alloc);
    try std.testing.expectEqual(@as(BlockId, 1), block);
    try std.testing.expectEqual(@as(BlockId, 0), irBuilder.current_block);
}
