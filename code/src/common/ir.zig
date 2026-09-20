const std = @import("std");
const Instruction = @import("mir.zig").Instruction;
const ArrayList = std.ArrayList;
const TypeInfo = @import("types.zig").TypeInfo;
const TypedOperand = @import("alloc.zig").TypedOperand;
const Operand = @import("alloc.zig").Operand;
const RegisterType = @import("register.zig").RegisterType;
const RegisterClass = @import("register.zig").RegisterClass;

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
    /// target-specific architectural register id
    id: u8,
    /// index within register class
    index: u8,
    type: RegisterType,
    /// measured in bytes
    width: u8,

    pub fn equal(self: @This(), other: @This()) bool {
        return self.id == other.id and self.index == other.index and self.type == other.type and self.width == other.width;
    }

    /// the nunber of registers required
    pub fn count(self: @This()) u8 {
        return @divExact(self.width, 8);
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
