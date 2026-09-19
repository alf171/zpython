const std = @import("std");
const ArrayList = std.ArrayList;
const c = @import("python.zig").c;
const StmtKind = @import("python.zig").StmtKind;
const getStmtKind = @import("python.zig").getStmtKind;
const getPyType = @import("python.zig").getPyType;
const printAstDump = @import("python.zig").printAstDump;
const parseTypeParams = @import("python.zig").parseTypeParams;
const hasDecorator = @import("python.zig").hasDecorator;
const parseTypeAnnotation = @import("python.zig").parseTypeAnnotation;
const parseConstant = @import("python.zig").parseConstant;
const makeStringLiteral = @import("python.zig").makeStringLiteral;

const Function = @import("common").function.Function;
const FunctionKind = @import("common").function.FunctionKind;
const ConstValue = @import("common").ir.ConstValue;
const ParsedConstant = @import("common").function.ParsedConstant;
const BasicBlock = @import("common").ir.BasicBlock;
const TypeBindings = @import("common").types.TypeBindings;
const TypeInfo = @import("common").types.TypeInfo;
const Operand = @import("common").alloc.Operand;
const TypedOperand = @import("common").alloc.TypedOperand;
const ValueRef = @import("common").ir.ValueRef;
const Param = @import("common").function.Param;
const TypeParam = @import("common").function.TypeParam;
const LocalInfo = @import("common").ir.LocalInfo;
const ClassId = @import("common").class.ClassId;
const ClassInfo = @import("common").class.ClassInfo;
const ClassInstance = @import("common").types.ClassInstance;
const Field = @import("common").class.Field;
const Method = @import("common").class.Method;
const LocalId = @import("common").ir.LocalId;
const Instruction = @import("common").mir.Instruction;
const BinOp = @import("common").ir.BinOp;
const CmpOp = @import("common").ir.CmpOp;
const Program = @import("common").program.Program;
const PhiInput = @import("common").mir.PhiInput;
const UnaryOp = @import("common").ir.UnaryOp;

const IrBuilder = @import("ir_builder.zig").IrBuilder;
const LocalValues = @import("ir_builder.zig").LocalValues;

const LoopBody = @import("loop.zig").LoopBody;
const walkLoop = @import("loop.zig").walkLoop;
const LoopCarry = @import("loop.zig").LoopCarry;

const PyObject = c.PyObject;

const ExprKind = enum { BinOp, UnaryOp, Compare, Constant, Name, Call, List, Tuple, Subscript, IfExp, Attribute, BoolOp, FString, Lambda, Unknown };

const BuiltinCall = enum { Print, Write, Range, Len, Int, I32, Float, F32, GlobalIdx, Max, Exp, Exp2, Type };

const BoolOp = enum { And, Or };

const RangeBounds = struct {
    start: TypedOperand,
    end: TypedOperand,
};

pub fn walkAstIntoBuilder(obj: ?*c.PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) !void {
    if (obj == null) return;

    const body = c.PyObject_GetAttrString(obj, "body");
    std.debug.assert(body != null);

    try walkStmtList(body, ir_builder, alloc);
}

pub fn walkStmtList(stmts: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) anyerror!void {
    const n = c.PyList_Size(stmts);
    var i: isize = 0;

    while (i < n) : (i += 1) {
        const raw_stmt = c.PyList_GetItem(stmts, i);
        try walkStmt(raw_stmt, ir_builder, alloc);
    }
}

pub fn walkStmt(raw_stmt: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) anyerror!void {
    const stmt = getStmtKind(raw_stmt);
    switch (stmt) {
        .Assign => try walkAssignment(raw_stmt, ir_builder, alloc),
        .AnnotatedAssign => try walkAnnotatedAssignment(raw_stmt, ir_builder, alloc),
        .Expr => {
            const value = c.PyObject_GetAttrString(raw_stmt, "value");
            const expr = try walkExpr(value, ir_builder, null, alloc);
            expr.deinit(alloc);
        },
        .If => try walkIf(raw_stmt, ir_builder, alloc),
        .While => try walkWhile(raw_stmt, ir_builder, alloc),
        .For => try walkFor(raw_stmt, ir_builder, alloc),
        .FuncDef => try walkFuncDef(raw_stmt, ir_builder, null, alloc),
        .Return => try walkReturn(raw_stmt, ir_builder, alloc),
        .Pass => {},
        // imports handled in `module.zig`
        .Import, .ImportFrom => {},
        .AugAssign => try walkAugAssignment(raw_stmt, ir_builder, alloc),
        .ClassDef => try walkClassDef(raw_stmt, ir_builder, alloc),
        else => {
            std.debug.print("unsupported statement type: {s}: ", .{getPyType(raw_stmt)});
            printAstDump(raw_stmt);
            return error.UnsupportedStatement;
        },
    }
}

/// class got declared in module
fn walkClassDef(stmt: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) !void {
    const name_obj = c.PyObject_GetAttrString(stmt, "name");
    std.debug.assert(name_obj != null);
    const raw_name = c.PyUnicode_AsUTF8(name_obj);
    std.debug.assert(raw_name != null);
    const name = std.mem.span(raw_name);

    const id: ClassId = (ir_builder.findClass(name) orelse return error.ClassNotDeclared).id;

    const bases_obj = c.PyObject_GetAttrString(stmt, "bases");
    std.debug.assert(bases_obj != null);
    const base_count = c.PyList_Size(bases_obj);
    if (base_count > 1) return error.MultipleInheritanceNotSupported;
    const base_class_id: ?ClassId = if (base_count == 0)
        null
    else blk: {
        const base_obj = c.PyList_GetItem(bases_obj, 0);
        std.debug.assert(base_obj != null);
        // TODO: support generics here too
        const id_obj = c.PyObject_GetAttrString(base_obj, "id");
        std.debug.assert(id_obj != null);
        const base_raw_name = c.PyUnicode_AsUTF8(id_obj);
        std.debug.assert(base_raw_name != null);
        const base_name = std.mem.span(base_raw_name);
        const base_class = ir_builder.findClass(base_name) orelse {
            std.debug.print("cant find base class {s}\n", .{base_name});
            return error.InvalidBaseClass;
        };
        break :blk base_class.id;
    };
    // set base class
    const class = ir_builder.getClass(id);
    class.base_class = base_class_id;

    const body_objs = c.PyObject_GetAttrString(stmt, "body");
    std.debug.assert(body_objs != null);
    for (0..@intCast(c.PyList_Size(body_objs))) |i| {
        const body_obj = c.PyList_GetItem(body_objs, @intCast(i));
        std.debug.assert(body_obj != null);
        switch (getStmtKind(body_obj)) {
            .FuncDef => try walkFuncDef(body_obj, ir_builder, id, alloc),
            // """ comment
            .Expr => {},
            else => |e| {
                std.debug.print("cant handle {s}\n", .{@tagName(e)});
                return error.NotImpl;
            },
        }
    }
}

fn walkAugAssignment(stmt: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) !void {
    const lhs = c.PyObject_GetAttrString(stmt, "target");
    std.debug.assert(lhs != null);
    const lhs_value = try walkExpr(lhs, ir_builder, null, alloc);

    const rhs = c.PyObject_GetAttrString(stmt, "value");
    const rhs_value = try walkExpr(rhs, ir_builder, null, alloc);

    const result: TypedOperand = .{
        .operand = ir_builder.nextTemp(),
        .type = lhs_value.type,
    };
    try ir_builder.emit(.{ .lir = .{ .binop = .{
        .dst = result,
        .lhs = lhs_value,
        .op = try getBinOp(stmt),
        .rhs = rhs_value,
    } } }, alloc);
    try storeAssignmentTarget(lhs, result, ir_builder, alloc);
}

fn walkAssignment(stmt: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) !void {
    const targets = c.PyObject_GetAttrString(stmt, "targets");
    std.debug.assert(targets != null);

    const lhs = c.PyList_GetItem(targets, 0);
    std.debug.assert(lhs != null);

    const rhs = c.PyObject_GetAttrString(stmt, "value");
    const rhs_value = try walkExpr(rhs, ir_builder, null, alloc);
    errdefer rhs_value.deinit(alloc);
    try storeAssignmentTarget(lhs, rhs_value, ir_builder, alloc);
}

fn storeAssignmentTarget(lhs: *PyObject, rhs_value: TypedOperand, ir_builder: *IrBuilder, alloc: std.mem.Allocator) !void {
    const expr = getExprKind(lhs);
    switch (expr) {
        // Assign(targets=[Name(id='x', ctx=Store())], value=Constant(value=3))
        .Name => {
            const id_obj = c.PyObject_GetAttrString(lhs, "id");
            std.debug.assert(id_obj != null);
            const id = c.PyUnicode_AsUTF8(id_obj);

            const local = try ir_builder.current_scope.getOrCreateLocal(std.mem.span(id), null, alloc);
            try ir_builder.current_scope.putLocalValues(local, rhs_value, alloc);
            try ir_builder.emit(.{ .lir = .{ .store_local = .{
                .local = .{
                    .id = local,
                    .name = try alloc.dupe(u8, std.mem.span(id)),
                    .type = try rhs_value.type.clone(alloc),
                },
                .src = try rhs_value.clone(alloc),
            } } }, alloc);
        },
        // Assign(targets=[Subscript(value=Name(id='items', ctx=Load()), slice=Constant(value=3), ctx=Store())], value=Constant(value=0))
        .Subscript => {
            const slice_obj = c.PyObject_GetAttrString(lhs, "slice");
            std.debug.assert(slice_obj != null);
            const slice = try walkExpr(slice_obj, ir_builder, null, alloc);
            defer slice.deinit(alloc);
            const value_obj = c.PyObject_GetAttrString(lhs, "value");
            std.debug.assert(value_obj != null);
            const container = try walkExpr(value_obj, ir_builder, null, alloc);
            defer container.deinit(alloc);

            switch (container.type) {
                .list => {
                    try ir_builder.emit(.{ .subscript_store = .{
                        .target = try container.clone(alloc),
                        .index = try slice.clone(alloc),
                        .src = .{ .top = rhs_value },
                    } }, alloc);
                },
                .instance => {
                    try ir_builder.emit(.{ .subscript_store = .{
                        .target = try container.clone(alloc),
                        .index = try slice.clone(alloc),
                        .src = .{ .top = rhs_value },
                    } }, alloc);
                },
                else => |e| {
                    std.debug.print("cant handle {s}\n", .{@tagName(e)});
                    return error.UnexpectedType;
                },
            }
        },
        // Assign(targets=[Tuple(elts=[Name(id='x', ctx=Store()), Name(id='y', ctx=Store())], ctx=Store())], value=Call(func=Name(id='foobar', ctx=Load()), args=[Constant(value=1), Constant(value=2)]))
        .Tuple => {
            defer rhs_value.deinit(alloc);
            const elts = c.PyObject_GetAttrString(lhs, "elts");
            std.debug.assert(elts != null);
            for (0..@intCast(c.PyList_Size(elts))) |i| {
                const elt = c.PyList_GetItem(elts, @intCast(i));
                std.debug.assert(elt != null);
                if (getExprKind(elt) != .Name) return error.UnsupportedTarget;
                const index: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = .i64,
                };
                try ir_builder.emit(.{ .lir = .{ .move = .{
                    .dst = index,
                    .src = .{ .constant = .{ .i64 = @intCast(i) } },
                } } }, alloc);

                const elem_type = switch (rhs_value.type) {
                    .tuple => |tuple| tuple.elements[i],
                    else => return error.ExpectTuple,
                };
                const elem_dst: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = elem_type,
                };

                try ir_builder.emit(.{ .subscript = .{
                    .dst = elem_dst,
                    .src = try rhs_value.clone(alloc),
                    .index = index,
                } }, alloc);

                const id_obj = c.PyObject_GetAttrString(elt, "id");
                std.debug.assert(id_obj != null);
                const id = c.PyUnicode_AsUTF8(id_obj);

                const local = try ir_builder.current_scope.getOrCreateLocal(std.mem.span(id), null, alloc);

                try ir_builder.current_scope.putLocalValues(
                    local,
                    .{
                        .operand = elem_dst.operand,
                        .type = elem_type,
                    },
                    alloc,
                );
                try ir_builder.emit(.{ .lir = .{ .store_local = .{
                    .local = .{
                        .id = local,
                        .name = try alloc.dupe(u8, std.mem.span(id)),
                        .type = try elem_type.clone(alloc),
                    },
                    .src = elem_dst,
                } } }, alloc);
            }
        },
        // Attribute(value=Name(id='self', ctx=Load()), attr='name', ctx=Store())
        .Attribute => {
            const instance_obj = c.PyObject_GetAttrString(lhs, "value");
            std.debug.assert(instance_obj != null);
            const attribute_obj = c.PyObject_GetAttrString(lhs, "attr");
            std.debug.assert(attribute_obj != null);

            const raw_field_name = c.PyUnicode_AsUTF8(attribute_obj);
            const field_name: []const u8 = std.mem.span(raw_field_name);
            std.debug.assert(raw_field_name != null);

            const instance_expr = try walkExpr(instance_obj, ir_builder, null, alloc);
            errdefer instance_expr.deinit(alloc);
            const instance = switch (instance_expr.type) {
                .instance => |id| id,
                else => return error.ExpectedInstance,
            };
            const class = ir_builder.getClass(instance.class_id);
            const field_idx = class.findFieldIdx(std.mem.span(raw_field_name));
            var field: ?*Field = null;

            // first time self so define field
            if (field_idx == null) {
                try class.fields.append(alloc, .{
                    .name = try alloc.dupe(u8, field_name),
                    .type = try rhs_value.type.clone(alloc),
                });
                field = &class.fields.items[class.fields.items.len - 1];
            } else {
                // reassignemnt scenario
                field = &class.fields.items[field_idx.?];
                var bindings: TypeBindings = .init(alloc);
                defer bindings.deinit(alloc);
                try field.?.type.unify(rhs_value.type, &bindings, alloc);
            }

            try ir_builder.emit(.{ .field_store = .{
                .instance = instance_expr,
                .field_index = field_idx orelse (class.fields.items.len - 1),
                .src = rhs_value,
            } }, alloc);
        },
        else => |e| {
            std.debug.print("cant handle {s}\n", .{@tagName(e)});
            return error.NotImpl;
        },
    }
}

// 1. AnnAssign(target=Name(id='a', ctx=Store()), annotation=..., value=Constant(value=5), simple=1)
// 2. AnnAssign(target=Name(id='a', ctx=Store()), annotation=..., value=List(elts=[Constant(value=1), Constant(value=2), Constant(value=3)], ctx=Load()), simple=1)
fn walkAnnotatedAssignment(stmt: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) !void {
    const target = c.PyObject_GetAttrString(stmt, "target");
    std.debug.assert(target != null);

    const annotation = c.PyObject_GetAttrString(stmt, "annotation");
    const annotation_type = try parseTypeAnnotation(annotation, ir_builder, alloc);
    defer annotation_type.deinit(alloc);
    const rhs = c.PyObject_GetAttrString(stmt, "value");
    const rhs_value = try walkExpr(rhs, ir_builder, annotation_type, alloc);

    switch (getExprKind(target)) {
        .Name => {
            const target_id_obj = c.PyObject_GetAttrString(target, "id");
            std.debug.assert(target_id_obj != null);
            const target_id = c.PyUnicode_AsUTF8(target_id_obj);
            const local = try ir_builder.current_scope.getOrCreateLocal(
                std.mem.span(target_id),
                annotation_type,
                alloc,
            );
            try ir_builder.current_scope.putLocalValues(local, rhs_value, alloc);
            try ir_builder.emit(.{ .lir = .{ .store_local = .{
                .local = .{
                    .id = local,
                    .name = try alloc.dupe(u8, std.mem.span(target_id)),
                    .type = try annotation_type.clone(alloc),
                },
                .src = try rhs_value.clone(alloc),
            } } }, alloc);
        },
        .Attribute => try storeAssignmentTarget(target, rhs_value, ir_builder, alloc),
        else => return error.UnsupportedTarget,
    }
}

pub fn walkExpr(stmt: *PyObject, ir_builder: *IrBuilder, expected_type: ?TypeInfo, alloc: std.mem.Allocator) !TypedOperand {
    switch (getExprKind(stmt)) {
        .BinOp => {
            const left = c.PyObject_GetAttrString(stmt, "left");
            const right = c.PyObject_GetAttrString(stmt, "right");

            const op = try getBinOp(stmt);
            // list repeat has expected_type propogate through only lhs
            const lhs_expected_type: ?TypeInfo = if (expected_type) |t|
                switch (t) {
                    .list => t,
                    else => null,
                }
            else
                null;
            // order here will impact temp numbering
            const lhs = try walkExpr(left, ir_builder, lhs_expected_type, alloc);
            errdefer lhs.deinit(alloc);
            const rhs = try walkExpr(right, ir_builder, null, alloc);
            errdefer rhs.deinit(alloc);

            if (lhs.type == .list and (rhs.type == .i64 or rhs.type == .i32)) {
                // list_repeat owns clones of both operands, so release these
                // expression temporaries after building the instruction.
                defer lhs.deinit(alloc);
                defer rhs.deinit(alloc);
                const dst: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = .{ .list = .{
                        .element = try (try lhs.type.list.element.clone(alloc)).toOwnedPointer(alloc),
                    } },
                };
                try ir_builder.emit(.{ .list_repeat = .{
                    .dst = dst,
                    .list = try lhs.clone(alloc),
                    .count = try rhs.clone(alloc),
                } }, alloc);
                return try dst.clone(alloc);
            }

            const result_type: TypeInfo = switch (lhs.type) {
                .instance => |instance| blk: {
                    const class = ir_builder.getClass(instance.class_id);
                    const func = try op.toClassBuiltin();
                    const method = class.findMethod(func) orelse {
                        std.debug.print("cant find method {s}\n", .{func});
                        return error.CantFindMethod;
                    };
                    const function = ir_builder.getFunction(method.function_id) orelse {
                        return error.CantFindFunction;
                    };
                    var bindings: TypeBindings = .init(alloc);
                    defer bindings.deinit(alloc);
                    const return_type = try bindings.inferReturnType(function, &.{ lhs, rhs }, alloc);
                    break :blk return_type;
                },
                else => blk: {
                    if (expected_type) |t| break :blk try t.clone(alloc);
                    break :blk try lhs.type.clone(alloc);
                },
            };

            const dst: TypedOperand = .{
                .operand = ir_builder.nextTemp(),
                .type = result_type,
            };
            try ir_builder.emit(.{ .lir = .{ .binop = .{
                .dst = dst,
                .op = op,
                .lhs = lhs,
                .rhs = rhs,
            } } }, alloc);
            return try dst.clone(alloc);
        },
        .UnaryOp => {
            const operand_obj = c.PyObject_GetAttrString(stmt, "operand");
            const src = try walkExpr(operand_obj, ir_builder, expected_type, alloc);
            const dst: TypedOperand = .{
                .operand = ir_builder.nextTemp(),
                .type = try src.type.clone(alloc),
            };
            const op = try getUnaryOp(stmt);
            try ir_builder.emit(.{ .lir = .{ .unaryop = .{
                .dst = dst,
                .op = op,
                .src = src,
            } } }, alloc);
            return try dst.clone(alloc);
        },
        .Constant => {
            const value_obj = c.PyObject_GetAttrString(stmt, "value");
            std.debug.assert(value_obj != null);
            // <variable> = None
            if (value_obj == c.Py_None()) {
                return .{ .operand = .unknown, .type = .void };
            }
            const parsed_constant = try parseConstant(value_obj, expected_type, alloc);
            switch (parsed_constant) {
                .immediate => |imm| {
                    const constant_type = if (expected_type) |t|
                        try t.clone(alloc)
                    else
                        imm.toType();
                    const dst: TypedOperand = .{
                        .operand = ir_builder.nextTemp(),
                        .type = constant_type,
                    };
                    try ir_builder.emit(.{ .lir = .{ .move = .{
                        .dst = dst,
                        .src = .{ .constant = imm },
                    } } }, alloc);
                    return try dst.clone(alloc);
                },
                .composite => |comp| {
                    const dst: TypedOperand = .{
                        .operand = ir_builder.nextTemp(),
                        .type = comp.type,
                    };
                    try ir_builder.emit(.{ .list_literal = .{
                        .dst = dst,
                        .elements = comp.elements,
                    } }, alloc);
                    return try dst.clone(alloc);
                },
            }
        },
        // List(elts=[Constant(value=1), Constant(value=2), Constant(value=3)], ctx=Load())
        .List => {
            const elements = c.PyObject_GetAttrString(stmt, "elts");
            std.debug.assert(elements != null);
            const len = c.PyList_Size(elements);
            var result: ArrayList(ValueRef) = .empty;
            errdefer result.deinit(alloc);

            for (0..@intCast(len)) |i| {
                const elem = c.PyList_GetItem(elements, @as(isize, @intCast(i)));
                std.debug.assert(elem != null);
                const expected_elem_type: ?TypeInfo = if (expected_type) |t| try t.getElementType() else null;
                // [conditional] use constant instead of an operand if we can
                switch (getExprKind(elem)) {
                    .Constant => {
                        const value = c.PyObject_GetAttrString(elem, "value");

                        const constant = try parseConstant(value, expected_elem_type, alloc);
                        switch (constant) {
                            .immediate => |imm| {
                                try result.append(alloc, .{ .constant = imm });
                            },
                            .composite => |comp| {
                                const dst: TypedOperand = .{
                                    .operand = ir_builder.nextTemp(),
                                    .type = comp.type,
                                };
                                try ir_builder.emit(.{ .list_literal = .{
                                    .dst = dst,
                                    .elements = comp.elements,
                                } }, alloc);

                                try result.append(alloc, .{ .top = try dst.clone(alloc) });
                            },
                        }
                    },
                    else => {
                        const expr = try walkExpr(elem, ir_builder, expected_elem_type, alloc);
                        try result.append(alloc, .{ .top = expr });
                    },
                }
            }
            const dst_type: TypeInfo = if (expected_type) |t|
                try t.clone(alloc)
            else blk: {
                if (result.items.len == 0) return error.NoTypeFound;
                const elem_type = try result.items[0].toType(alloc);
                break :blk .{
                    .list = .{ .element = try elem_type.toOwnedPointer(alloc) },
                };
            };

            const dst: TypedOperand = .{
                .operand = ir_builder.nextTemp(),
                .type = dst_type,
            };
            try ir_builder.emit(.{ .list_literal = .{
                .dst = dst,
                .elements = try result.toOwnedSlice(alloc),
            } }, alloc);
            return try dst.clone(alloc);
        },
        // Tuple(elts=[Name(id='x', ctx=Load()), Name(id='y', ctx=Load())], ctx=Load())
        .Tuple => {
            const elts_obj = c.PyObject_GetAttrString(stmt, "elts");
            std.debug.assert(elts_obj != null);
            const len: usize = @intCast(c.PyList_Size(elts_obj));
            const expected_elements = if (expected_type) |t|
                switch (t) {
                    .tuple => |tup| blk: {
                        if (tup.elements.len != len) return error.MismatchingTypes;
                        break :blk tup.elements;
                    },
                    else => null,
                }
            else
                null;
            var elements = try alloc.alloc(ValueRef, len);
            var element_types = try alloc.alloc(TypeInfo, len);
            for (0..len) |i| {
                const elem_obj = c.PyList_GetItem(elts_obj, @intCast(i));
                std.debug.assert(elem_obj != null);
                const expected_elem_type: ?TypeInfo = if (expected_elements) |elem|
                    elem[i]
                else
                    null;
                const elem_op = try walkExpr(elem_obj, ir_builder, expected_elem_type, alloc);
                elements[i] = ValueRef{
                    .top = elem_op,
                };
                element_types[i] = try elem_op.type.clone(alloc);
            }

            const dst = ir_builder.nextTemp();
            const typed_dst: TypedOperand = .{
                .operand = dst,
                .type = .{ .tuple = .{ .elements = element_types } },
            };
            try ir_builder.emit(.{
                .tuple_literal = .{
                    .dst = typed_dst,
                    .elements = elements,
                },
            }, alloc);
            return try typed_dst.clone(alloc);
        },
        // Subscript(value=Name(id='items', ctx=Load()), slice=Constant(value=0), ctx=Load())
        .Subscript => {
            const value_obj = c.PyObject_GetAttrString(stmt, "value");
            std.debug.assert(value_obj != null);

            const slice = c.PyObject_GetAttrString(stmt, "slice");

            const value = try walkExpr(value_obj, ir_builder, null, alloc);
            const index = try walkExpr(slice, ir_builder, null, alloc);

            switch (value.type) {
                .list => |list| {
                    if (index.type != .i64 and index.type != .i32 and index.type != .any) {
                        return error.ArrayIndexMustBeInt;
                    }
                    const elem_type = list.element.*;

                    const dst: TypedOperand = .{
                        .operand = ir_builder.nextTemp(),
                        .type = try elem_type.clone(alloc),
                    };
                    try ir_builder.emit(.{ .subscript = .{
                        .dst = dst,
                        .src = value,
                        .index = index,
                    } }, alloc);
                    return try dst.clone(alloc);
                },
                .tuple => |tuple| {
                    if (getExprKind(slice) != .Constant) {
                        return error.TupleIndexMustBeConstant;
                    }
                    const index_value_obj = c.PyObject_GetAttrString(slice, "value");
                    std.debug.assert(index_value_obj != null);

                    const raw_index = c.PyLong_AsLong(index_value_obj);
                    const tuple_index: usize = @intCast(raw_index);
                    if (tuple_index < 0) return error.TupleIndexOutOfBounds;
                    if (tuple_index >= tuple.elements.len) return error.TupleIndexOutOfBounds;

                    const dst: TypedOperand = .{
                        .operand = ir_builder.nextTemp(),
                        .type = try tuple.elements[tuple_index].clone(alloc),
                    };
                    try ir_builder.emit(.{ .subscript = .{
                        .dst = dst,
                        .src = value,
                        .index = index,
                    } }, alloc);
                    return try dst.clone(alloc);
                },
                .instance => |instance| {
                    const class = ir_builder.getClass(instance.class_id);
                    const getitem_method = class.findMethod("__getitem__") orelse {
                        return error.CantFindGetMethod;
                    };
                    const getitem_function = ir_builder.getFunction(getitem_method.function_id) orelse {
                        return error.CantFindGetMethod;
                    };

                    var bindings: TypeBindings = .init(alloc);
                    defer bindings.deinit(alloc);
                    const return_type = try bindings.inferReturnType(getitem_function, &.{ value, index }, alloc);

                    const dst: TypedOperand = .{
                        .operand = ir_builder.nextTemp(),
                        .type = return_type,
                    };

                    try ir_builder.emit(.{ .subscript = .{
                        .dst = dst,
                        .src = value,
                        .index = index,
                    } }, alloc);

                    return try dst.clone(alloc);
                },
                else => |e| {
                    std.debug.print("cant handle {s}\n", .{@tagName(e)});
                    return error.UnsupportedIndex;
                },
            }
        },
        .Name => {
            const id_obj = c.PyObject_GetAttrString(stmt, "id");
            std.debug.assert(id_obj != null);

            const id = c.PyUnicode_AsUTF8(id_obj);
            std.debug.assert(id != null);

            const name = std.mem.span(id);
            const localId = try ir_builder.current_scope.getOrCreateLocal(name, null, alloc);

            if (ir_builder.current_scope.local_values.map.get(localId)) |value| {
                return try value.clone(alloc);
            }

            if (ir_builder.findImportModule(name)) |module_id| {
                return .{
                    .operand = .unknown,
                    .type = .{ .module = module_id },
                };
            }

            const maybe_function = if (ir_builder.findImportedFunction(name)) |imported| blk: {
                break :blk ir_builder.getModuleFunction(imported.id, imported.function_name) orelse {
                    return error.CantFindFunction;
                };
            } else blk: {
                break :blk ir_builder.getModuleFunction(ir_builder.current_module_id, name) orelse
                    ir_builder.findFunction(name);
            };
            if (maybe_function) |function| {
                var params = try alloc.alloc(TypeInfo, function.params.len);
                for (function.params, 0..) |param, i| {
                    params[i] = try param.type.clone(alloc);
                }
                const function_dst: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = .{ .callable = .{
                        .params = params,
                        .returns = try (try function.return_type.clone(alloc)).toOwnedPointer(alloc),
                    } },
                };
                // declare function we will return
                try ir_builder.emit(.{
                    .function_ref = .{
                        .dst = function_dst,
                        .label = try alloc.dupe(u8, function.label),
                    },
                }, alloc);
                return try function_dst.clone(alloc);
            }
            const local = try ir_builder.current_scope.locals.items[localId].clone(alloc);
            const dst: TypedOperand = .{
                .operand = ir_builder.nextTemp(),
                .type = local.type,
            };
            try ir_builder.emit(.{ .lir = .{ .load_local = .{
                .dst = dst,
                .local = local,
            } } }, alloc);
            return try dst.clone(alloc);
        },
        // Compare(left=Constant(1),ops=[Lt()],comparators=[Constant(2)])
        .Compare => {
            const left_obj = c.PyObject_GetAttrString(stmt, "left");
            const comparators = c.PyObject_GetAttrString(stmt, "comparators");
            std.debug.assert(left_obj != null);
            std.debug.assert(comparators != null);
            const right_obj = c.PyList_GetItem(comparators, 0);
            std.debug.assert(right_obj != null);

            const lhs = try walkExpr(left_obj, ir_builder, null, alloc);
            const rhs = try walkExpr(right_obj, ir_builder, null, alloc);
            const dst: TypedOperand = .{ .operand = ir_builder.nextTemp(), .type = .bool };
            const op = try getCompareOp(stmt);

            try ir_builder.emit(.{ .lir = .{ .compare = .{
                .dst = dst,
                .lhs = lhs,
                .op = op,
                .rhs = rhs,
            } } }, alloc);

            return try dst.clone(alloc);
        },
        .Call => {
            const func = c.PyObject_GetAttrString(stmt, "func");
            std.debug.assert(func != null);
            const func_kind = getPyType(func);

            if (std.mem.eql(u8, func_kind, "Name")) {
                return walkNamedCall(stmt, func, ir_builder, expected_type, alloc);
            } else if (std.mem.eql(u8, func_kind, "Attribute")) {
                return walkMethodCall(stmt, func, ir_builder, alloc);
            } else if (std.mem.eql(u8, func_kind, "Subscript")) {
                return walkGenericCall(stmt, func, ir_builder, alloc);
            }
            std.debug.print("unsupported callee type: {s}\n", .{func_kind});
            return error.UnsupportedCallee;
        },
        // IfExp(test=Name(id='c', ctx=Load()), body=Constant(value='FALSE'), orelse=Constant(value='TRUE'))
        .IfExp => {
            const test_obj = c.PyObject_GetAttrString(stmt, "test");
            const body_obj = c.PyObject_GetAttrString(stmt, "body");
            const orelse_obj = c.PyObject_GetAttrString(stmt, "orelse");
            std.debug.assert(test_obj != null);
            std.debug.assert(body_obj != null);
            std.debug.assert(orelse_obj != null);

            const condition = try walkExpr(test_obj, ir_builder, null, alloc);
            const if_value = try walkExpr(body_obj, ir_builder, null, alloc);
            const else_value = try walkExpr(orelse_obj, ir_builder, null, alloc);

            const dst: TypedOperand = .{
                .operand = ir_builder.nextTemp(),
                .type = try if_value.type.clone(alloc),
            };
            try ir_builder.emit(.{ .lir = .{ .select = .{
                .dst = dst,
                .condition = condition,
                .if_value = .{ .top = if_value },
                .else_value = .{ .top = else_value },
            } } }, alloc);

            return try dst.clone(alloc);
        },
        // Attribute(value=Name(id='self', ctx=Load()), attr='name', ctx=Store())
        .Attribute => {
            const value = c.PyObject_GetAttrString(stmt, "value");
            std.debug.assert(value != null);
            const instance_expr = try walkExpr(value, ir_builder, null, alloc);
            errdefer instance_expr.deinit(alloc);
            const instance = switch (instance_expr.type) {
                .instance => |id| id,
                else => {
                    const got = try instance_expr.type.toString(alloc);
                    defer alloc.free(got);
                    std.debug.print("attribute must be an instance; got {s}\n", .{got});
                    return error.UnexpectedType;
                },
            };

            const name_obj = c.PyObject_GetAttrString(stmt, "attr");
            std.debug.assert(name_obj != null);
            const raw_name = c.PyUnicode_AsUTF8(name_obj);
            std.debug.assert(raw_name != null);

            const class = ir_builder.getClass(instance.class_id);
            const name = std.mem.span(raw_name);
            const field_index = class.findFieldIdx(name) orelse {
                std.debug.print("cant find {s}\n", .{name});
                return error.CantFindField;
            };
            const field = &class.fields.items[field_index];
            const resolved_field_type = try class.resolveFieldType(field, instance, alloc);

            const dst: TypedOperand = .{
                .operand = ir_builder.nextTemp(),
                .type = resolved_field_type,
            };
            try ir_builder.emit(.{ .field_load = .{
                .dst = dst,
                .instance = instance_expr,
                .field_index = field_index,
            } }, alloc);
            return try dst.clone(alloc);
        },
        // BoolOp(op=And(), values=[Compare(left=Attribute(value=Name(id='self', ctx=Load()), attr='rows', ctx=Load()), ops=[Eq()], comparators=[Constant(value=1)]), Compare(left=Name(id='rows', ctx=Load()), ops=[NotEq()], comparators=[Constant(value=1)])])
        // a_left a_op a_right <op> b_left b_op b_right
        .BoolOp => {
            const op_obj = c.PyObject_GetAttrString(stmt, "op");
            std.debug.assert(op_obj != null);
            const op = try getBoolOp(getPyType(op_obj));
            switch (op) {
                .And => {
                    const values_obj = c.PyObject_GetAttrString(stmt, "values");
                    std.debug.assert(values_obj != null);
                    std.debug.assert(c.PyList_Size(values_obj) == 2);
                    const lhs_obj = c.PyList_GetItem(values_obj, 0);
                    std.debug.assert(lhs_obj != null);
                    const lhs = try walkExpr(lhs_obj, ir_builder, null, alloc);
                    std.debug.assert(lhs.type == .bool);
                    const rhs_obj = c.PyList_GetItem(values_obj, 1);
                    std.debug.assert(rhs_obj != null);
                    const rhs = try walkExpr(rhs_obj, ir_builder, null, alloc);
                    std.debug.assert(rhs.type == .bool);
                    const dst: TypedOperand = .{
                        .operand = ir_builder.nextTemp(),
                        .type = .bool,
                    };
                    try ir_builder.emit(.{
                        .lir = .{ .select = .{
                            .dst = dst,
                            .condition = lhs,
                            .if_value = .{ .top = rhs },
                            .else_value = .{ .constant = .{ .bool = false } },
                        } },
                    }, alloc);
                    return try dst.clone(alloc);
                },
                else => return error.NotImpl,
            }
        },
        // JoinedStr(values=[FormattedValue(value=Attribute(value=Name(id='self', ctx=Load()), attr='name', ctx=Load()), conversion=-1), Constant(value=' says '), FormattedValue(value=Attribute(value=Name(id='self', ctx=Load()), attr='sounds', ctx=Load()), conversion=-1)])
        .FString => {
            const values = c.PyObject_GetAttrString(stmt, "values");
            std.debug.assert(values != null);
            var result: ?TypedOperand = null;
            errdefer {
                if (result) |value| value.deinit(alloc);
            }
            for (0..@intCast(c.PyList_Size(values))) |i| {
                const value_obj = c.PyList_GetItem(values, @intCast(i));
                std.debug.assert(value_obj != null);
                const value = if (std.mem.eql(u8, getPyType(value_obj), "FormattedValue")) blk: {
                    const inner_value_obj = c.PyObject_GetAttrString(value_obj, "value");
                    std.debug.assert(inner_value_obj != null);
                    const val = try walkExpr(inner_value_obj, ir_builder, null, alloc);
                    break :blk val;
                } else blk: {
                    break :blk try walkExpr(value_obj, ir_builder, null, alloc);
                };
                if (result) |lhs| {
                    const dst: TypedOperand = .{
                        .operand = ir_builder.nextTemp(),
                        .type = try lhs.type.clone(alloc),
                    };
                    const args = try alloc.alloc(TypedOperand, 2);
                    args[0] = lhs;
                    args[1] = value;
                    errdefer {
                        lhs.deinit(alloc);
                        value.deinit(alloc);
                        alloc.free(args);
                    }
                    try ir_builder.emit(.{ .function_call = .{
                        .dst = try dst.clone(alloc),
                        .callee = .{ .direct = try alloc.dupe(u8, "_concat__string_concat") },
                        .args = args,
                    } }, alloc);
                    result = dst;
                } else {
                    result = value;
                }
            }
            return result orelse blk: {
                const string = try makeStringLiteral("", alloc);
                const composite = string.composite;

                const dst: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = composite.type,
                };

                try ir_builder.emit(.{ .list_literal = .{
                    .dst = dst,
                    .elements = composite.elements,
                } }, alloc);
                break :blk try dst.clone(alloc);
            };
        },
        // Lambda(args=arguments(args=[arg(arg='x'), arg(arg='y')]), body=BinOp(left=Name(id='x', ctx=Load()), op=Add(), right=Name(id='y', ctx=Load())))
        .Lambda => {
            const callable_type = expected_type orelse {
                return error.LambdaNeedsTypeDeclared;
            };
            const callable = switch (callable_type) {
                .callable => |callable| callable,
                else => return error.LambdaNeedsCallableType,
            };
            const lambda = c.PyObject_GetAttrString(stmt, "args");
            std.debug.assert(lambda != null);
            const args_obj = c.PyObject_GetAttrString(lambda, "args");
            std.debug.assert(args_obj != null);
            const arity: usize = @intCast(c.PyList_Size(args_obj));
            const params = try alloc.alloc(Param, arity);
            for (0..arity) |i| {
                const arg_obj = c.PyList_GetItem(args_obj, @intCast(i));
                std.debug.assert(arg_obj != null);
                const name_obj = c.PyObject_GetAttrString(arg_obj, "arg");
                std.debug.assert(name_obj != null);
                const name = std.mem.span(c.PyUnicode_AsUTF8(name_obj));
                params[i] = .{
                    .name = try alloc.dupe(u8, name),
                    .type = try callable.params[i].clone(alloc),
                };
            }
            const id = ir_builder.nextFunctionId();
            const callee_name = try std.fmt.allocPrint(alloc, "__lambda_{d}", .{id});
            defer alloc.free(callee_name);
            const function = try Function.init(
                callee_name,
                id,
                ir_builder.current_module_id,
                ir_builder.current_module_name,
                params,
                try alloc.alloc(TypeParam, 0),
                try callable.returns.*.clone(alloc),
                ir_builder.function_origin,
                .host,
                false,
                alloc,
            );
            try ir_builder.program.functions.append(alloc, function);

            const saved_function = ir_builder.current_function;
            const saved_block = ir_builder.current_block;
            var saved_local_values = try ir_builder.current_scope.local_values.clone(alloc);
            defer saved_local_values.deinit(alloc);
            ir_builder.current_function = id - 1;
            ir_builder.current_block = 0;
            ir_builder.current_scope.local_values.clear(alloc);
            for (ir_builder.currentFunction().params, 0..) |param, i| {
                const f_dst: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = try param.type.clone(alloc),
                };
                try ir_builder.emit(.{ .function_param = .{
                    .dst = f_dst,
                    .name = try alloc.dupe(u8, param.name),
                    .index = i,
                } }, alloc);
                const local = try ir_builder.current_scope.getOrCreateLocal(param.name, param.type, alloc);
                try ir_builder.current_scope.putLocalValues(local, try f_dst.clone(alloc), alloc);
            }
            const body_obj = c.PyObject_GetAttrString(stmt, "body");
            std.debug.assert(body_obj != null);
            // lambda dont have explicit returns!
            const body = try walkExpr(body_obj, ir_builder, callable.returns.*, alloc);
            // handle null case as no return!
            try ir_builder.emit(.{ .function_return = .{
                .value = if (body.type != .void) body else null,
            } }, alloc);

            ir_builder.current_function = saved_function;
            ir_builder.current_block = saved_block;
            try ir_builder.current_scope.restoreLocalValues(&saved_local_values, alloc);
            const dst: TypedOperand = .{
                .operand = ir_builder.nextTemp(),
                .type = try callable_type.clone(alloc),
            };

            try ir_builder.emit(.{
                .function_ref = .{
                    .dst = try dst.clone(alloc),
                    .label = try alloc.dupe(u8, function.label),
                },
            }, alloc);
            return dst;
        },
        .Unknown => {
            const name = getPyType(stmt);
            std.debug.print("unsupported expr type: {s}: ", .{name});
            printAstDump(stmt);
            return error.ExprUnknown;
        },
    }
}

// Expr(value=Call(func=Name(id="print"),args=[BinOp(...)]))
fn walkNamedCall(
    stmt: *PyObject,
    func: *PyObject,
    ir_builder: *IrBuilder,
    expected_type: ?TypeInfo,
    alloc: std.mem.Allocator,
) anyerror!TypedOperand {
    const func_id = c.PyObject_GetAttrString(func, "id");
    std.debug.assert(func_id != null);

    const name = c.PyUnicode_AsUTF8(func_id);
    std.debug.assert(name != null);

    const args = c.PyObject_GetAttrString(stmt, "args");
    std.debug.assert(args != null);

    const builtin = getBuiltinCall(std.mem.span(name));

    if (builtin) |b| {
        switch (b) {
            .Print => {
                std.debug.assert(c.PyList_Size(args) == 1);
                const arg0 = c.PyList_GetItem(args, 0);
                std.debug.assert(arg0 != null);
                const src = try walkExpr(arg0, ir_builder, null, alloc);

                const keywords = c.PyObject_GetAttrString(stmt, "keywords");
                std.debug.assert(keywords != null);
                var end: ?TypedOperand = null;
                const keyword_length = c.PyList_Size(keywords);
                std.debug.assert(keyword_length == 0 or keyword_length == 1);
                if (keyword_length == 1) {
                    const end_obj = c.PyList_GetItem(keywords, 0);
                    std.debug.assert(end_obj != null);
                    const arg_obj = c.PyObject_GetAttrString(end_obj, "arg");
                    std.debug.assert(arg_obj != null);
                    const label = c.PyUnicode_AsUTF8(arg_obj);
                    if (!std.mem.eql(u8, std.mem.span(label), "end")) {
                        return error.ExpectedEnd;
                    }
                    const end_value_obj = c.PyObject_GetAttrString(end_obj, "value");
                    std.debug.assert(end_value_obj != null);
                    end = try walkExpr(end_value_obj, ir_builder, null, alloc);
                }

                try ir_builder.emit(Instruction{ .print = .{
                    .src = src,
                    .end = end,
                } }, alloc);
                return .{ .operand = .unknown, .type = .any };
            },
            .Write => {
                std.debug.assert(c.PyList_Size(args) == 3);
                const arg0 = c.PyList_GetItem(args, 0);
                std.debug.assert(arg0 != null);
                const fd = try walkExpr(arg0, ir_builder, null, alloc);
                const arg1 = c.PyList_GetItem(args, 1);
                std.debug.assert(arg1 != null);
                const buf = try walkExpr(arg1, ir_builder, null, alloc);
                const arg2 = c.PyList_GetItem(args, 2);
                std.debug.assert(arg2 != null);
                const len = try walkExpr(arg2, ir_builder, null, alloc);
                switch (buf.type) {
                    .list => {
                        // gross but we need to increment past the book keeping size value
                        const eight: TypedOperand = .{ .operand = ir_builder.nextTemp(), .type = .i64 };
                        try ir_builder.emit(.{ .lir = .{ .move = .{
                            .dst = eight,
                            .src = .{ .constant = .{ .i64 = 8 } },
                        } } }, alloc);
                        const data: TypedOperand = .{
                            .operand = ir_builder.nextTemp(),
                            .type = .ptr,
                        };
                        // write returns a pointer
                        try ir_builder.emit(.{ .lir = .{ .binop = .{
                            .dst = data,
                            .lhs = buf,
                            .op = .add,
                            .rhs = eight,
                        } } }, alloc);
                        const write_args = try alloc.alloc(TypedOperand, 3);
                        write_args[0] = fd;
                        write_args[1] = try data.clone(alloc);
                        write_args[2] = len;
                        try ir_builder.emit(.{
                            .function_call = .{
                                .dst = null,
                                .args = write_args,
                                .callee = .{ .direct = try alloc.dupe(u8, "write") },
                            },
                        }, alloc);
                    },
                    .tuple => {
                        const write_args = try alloc.alloc(TypedOperand, 3);
                        write_args[0] = fd;
                        write_args[1] = buf;
                        write_args[2] = len;
                        try ir_builder.emit(.{
                            .function_call = .{
                                .dst = null,
                                .args = write_args,
                                .callee = .{ .direct = try alloc.dupe(u8, "write") },
                            },
                        }, alloc);
                    },
                    else => |e| {
                        std.debug.print("cant write type {s}\n", .{@tagName(e)});
                        return error.UnsupportedWriteType;
                    },
                }
                return .{ .operand = .unknown, .type = .void };
            },
            .Len => {
                std.debug.assert(c.PyList_Size(args) == 1);
                const arg0 = c.PyList_GetItem(args, 0);
                std.debug.assert(arg0 != null);
                const value = try walkExpr(arg0, ir_builder, null, alloc);
                const dst: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    // HACK: dont hardcode width
                    .type = .i32,
                };
                try ir_builder.emit(.{ .len = .{
                    .dst = dst,
                    .value = value,
                } }, alloc);
                return try dst.clone(alloc);
            },
            // Call(func=Name(id='range', ctx=Load()), args=[Constant(value=0), Constant(value=10)])
            .Range => {
                const bounds: RangeBounds = switch (c.PyList_Size(args)) {
                    1 => blk: {
                        const endItem = c.PyList_GetItem(args, 0);
                        std.debug.assert(endItem != null);
                        const end = try walkExpr(endItem, ir_builder, null, alloc);

                        const start: TypedOperand = .{
                            .operand = ir_builder.nextTemp(),
                            .type = try end.type.clone(alloc),
                        };
                        const zero: ConstValue = switch (start.type) {
                            .i64 => .{ .i64 = 0 },
                            .i32 => .{ .i32 = 0 },
                            else => return error.InvalidRangeType,
                        };
                        try ir_builder.emit(.{ .lir = .{ .move = .{
                            .dst = start,
                            .src = .{ .constant = zero },
                        } } }, alloc);

                        break :blk .{
                            .start = try start.clone(alloc),
                            .end = end,
                        };
                    },
                    2 => blk: {
                        const startItem = c.PyList_GetItem(args, 0);
                        std.debug.assert(startItem != null);
                        const start = try walkExpr(startItem, ir_builder, null, alloc);
                        const endItem = c.PyList_GetItem(args, 1);
                        std.debug.assert(endItem != null);
                        const end = try walkExpr(endItem, ir_builder, null, alloc);
                        break :blk RangeBounds{ .start = start, .end = end };
                    },
                    else => return error.InvalidBounds,
                };

                const dst = ir_builder.nextTemp();

                const type_: TypeInfo = .{
                    .lazy = .{
                        .value = try TypeInfo.toOwnedPointer(.{
                            .iterable = .{
                                // .element = try TypeInfo.toOwnedPointer(.i64, alloc),
                                .element = try (try bounds.end.type.clone(alloc)).toOwnedPointer(alloc),
                            },
                        }, alloc),
                    },
                };
                const typed_dst = TypedOperand{ .operand = dst, .type = type_ };
                try ir_builder.emit(.{ .range = .{
                    .dst = typed_dst,
                    .start = bounds.start,
                    .end = bounds.end,
                } }, alloc);
                return try typed_dst.clone(alloc);
            },
            .Int, .I32, .Float, .F32 => |t| {
                std.debug.assert(c.PyList_Size(args) == 1);
                const arg0 = c.PyList_GetItem(args, 0);
                std.debug.assert(arg0 != null);
                const dst_type: TypeInfo = switch (t) {
                    .Int => .i64,
                    .I32 => .i32,
                    .F32 => .f32,
                    .Float => .f64,
                    else => unreachable,
                };
                const value = try walkExpr(arg0, ir_builder, null, alloc);
                const dst: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = dst_type,
                };
                try ir_builder.emit(.{ .lir = .{ .cast = .{
                    .dst = dst,
                    .src = value,
                } } }, alloc);
                return try dst.clone(alloc);
            },
            .GlobalIdx => {
                if (c.PyList_Size(args) != 1) {
                    std.debug.print("global idx doesn't have exactly 1 arg\n", .{});
                    return error.InvalidGlobalIdx;
                }
                const arg_obj = c.PyList_GetItem(args, 0);
                const arg = try walkExpr(arg_obj, ir_builder, null, alloc);

                const dst: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = .i32,
                };

                try ir_builder.emit(.{ .global_idx = .{
                    .dst = dst,
                    .axis = .{ .top = arg },
                } }, alloc);

                return try dst.clone(alloc);
            },
            .Max => {
                std.debug.assert(c.PyList_Size(args) == 2);
                const lhs_obj = c.PyList_GetItem(args, 0);
                const lhs = try walkExpr(lhs_obj, ir_builder, expected_type, alloc);
                const rhs_obj = c.PyList_GetItem(args, 1);
                const rhs = try walkExpr(rhs_obj, ir_builder, lhs.type, alloc);

                if (!lhs.type.equal(rhs.type)) {
                    const lhs_type_str = try lhs.type.toString(alloc);
                    defer alloc.free(lhs_type_str);
                    const rhs_type_str = try rhs.type.toString(alloc);
                    defer alloc.free(rhs_type_str);
                    std.debug.print("lhs type ({s}) and rhs type ({s}) do not match\n", .{ lhs_type_str, rhs_type_str });
                    return error.MatchTypesDontMatch;
                }

                const compare: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = .bool,
                };

                try ir_builder.emit(.{ .lir = .{ .compare = .{
                    .dst = compare,
                    .lhs = lhs,
                    .op = .gt,
                    .rhs = rhs,
                } } }, alloc);

                const dst: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = try lhs.type.clone(alloc),
                };

                try ir_builder.emit(.{ .lir = .{ .select = .{
                    .dst = dst,
                    .condition = compare,
                    .if_value = .{ .top = try lhs.clone(alloc) },
                    .else_value = .{ .top = try rhs.clone(alloc) },
                } } }, alloc);

                return try dst.clone(alloc);
            },
            .Exp => {
                std.debug.assert(c.PyList_Size(args) == 1);
                const arg = c.PyList_GetItem(args, 0);
                std.debug.assert(arg != null);
                const callee_args = try alloc.alloc(TypedOperand, 1);
                callee_args[0] = try walkExpr(arg, ir_builder, null, alloc);
                const dst: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = .f64,
                };
                // this pattern only works on the cpu
                try ir_builder.emit(.{ .function_call = .{
                    .dst = dst,
                    .callee = .{ .direct = try alloc.dupe(u8, "exp") },
                    .args = callee_args,
                } }, alloc);
                return try dst.clone(alloc);
            },
            .Exp2 => {
                std.debug.assert(c.PyList_Size(args) == 1);
                const arg = c.PyList_GetItem(args, 0);
                std.debug.assert(arg != null);
                const callee_arg = try walkExpr(arg, ir_builder, null, alloc);
                const dst: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = try callee_arg.type.clone(alloc),
                };
                try ir_builder.emit(.{ .lir = .{ .unaryop = .{
                    .dst = dst,
                    .op = .exp2,
                    .src = callee_arg,
                } } }, alloc);
                return try dst.clone(alloc);
            },
            .Type => {
                std.debug.assert(c.PyList_Size(args) == 1);
                const arg = c.PyList_GetItem(args, 0);
                std.debug.assert(arg != null);
                const value = try walkExpr(arg, ir_builder, null, alloc);
                defer value.deinit(alloc);

                const type_name = try value.type.toString(alloc);
                defer alloc.free(type_name);

                const string = try makeStringLiteral(type_name, alloc);
                const composite = string.composite;
                const dst: TypedOperand = .{
                    .operand = ir_builder.nextTemp(),
                    .type = composite.type,
                };
                try ir_builder.emit(.{ .list_literal = .{
                    .dst = dst,
                    .elements = composite.elements,
                } }, alloc);
                return try dst.clone(alloc);
            },
        }
    }
    // class constructor
    const constructor_init = if (ir_builder.findClass(std.mem.span(name))) |class| blk: {
        const init_method = class.findMethod("__init__") orelse {
            return error.CantFindInit;
        };
        break :blk ir_builder.getFunction(init_method.function_id) orelse {
            return error.CantFindInit;
        };
    } else null;
    if (constructor_init) |init| {
        if (init.params.len != c.PyList_Size(args) + 1) {
            return error.InvalidArgCount;
        }
    }

    // arguments are params only declared at call site
    var arguments: ArrayList(TypedOperand) = .empty;
    errdefer {
        for (arguments.items) |arg| {
            arg.deinit(alloc);
        }
        arguments.deinit(alloc);
    }
    // get function type
    const name_slice = std.mem.span(name);
    const direct_callee = if (ir_builder.findImportedFunction(name_slice)) |imported|
        ir_builder.getModuleFunction(imported.id, imported.function_name)
    else
        // in the scenario of a conflict, we want to prefer our module over runtime
        ir_builder.getModuleFunction(ir_builder.current_module_id, name_slice) orelse
            ir_builder.findFunction(name_slice);

    if (direct_callee) |function| {
        const expected_count = function.params.len + @intFromBool(function.kind == .gpu_kernel);
        if (c.PyList_Size(args) != expected_count) {
            return error.InvalidArgCount;
        }
    }

    for (0..@intCast(c.PyList_Size(args))) |i| {
        const arg_obj = c.PyList_GetItem(args, @intCast(i));
        std.debug.assert(arg_obj != null);
        const param_type = if (constructor_init) |init|
            init.params[i + 1].type
        else if (direct_callee) |function|
            // hack to protect against type inference on work_items
            if (function.kind == .gpu_kernel and i == function.params.len)
                null
            else
                function.params[i].type
        else
            null;
        // dont infer type from generic args
        const expected_arg_type = if (param_type) |t|
            if (!t.containsGenericVariable()) t else null
        else
            null;
        const arg = try walkExpr(arg_obj, ir_builder, expected_arg_type, alloc);
        try arguments.append(alloc, arg);
    }

    if (ir_builder.getLocal(name_slice) catch null) |local_id| {
        if (ir_builder.current_scope.local_values.map.get(local_id)) |callee| {
            if (callee.type == .callable) {
                const maybe_dst: ?TypedOperand = if (callee.type.callable.returns.* == .void)
                    null
                else
                    .{
                        .operand = ir_builder.nextTemp(),
                        .type = callee.type.callable.returns.*,
                    };

                try ir_builder.emit(.{
                    .function_call = .{
                        .callee = .{ .indirect = try callee.clone(alloc) },
                        .dst = if (maybe_dst) |dst| try dst.clone(alloc) else null,
                        .args = try arguments.toOwnedSlice(alloc),
                    },
                }, alloc);

                if (maybe_dst) |dst| return dst;
                return TypedOperand{ .operand = .unknown, .type = .void };
            }
        }
    }

    if (direct_callee) |function| {
        return emitResolvedCall(function, &arguments, ir_builder, alloc);
    }

    // class constructor
    if (ir_builder.findClass(name_slice)) |class| {
        const init = constructor_init orelse return error.CantFindInit;
        var bindings: TypeBindings = .init(alloc);
        defer bindings.deinit(alloc);

        for (init.params[1..], arguments.items) |param, arg| {
            try TypeInfo.unify(param.type, arg.type, &bindings, alloc);
        }

        const instance_args = try alloc.alloc(TypeInfo, class.type_params.len);
        errdefer alloc.free(instance_args);

        for (class.type_params, 0..) |type_param, i| {
            const bound_type = bindings.get(type_param.id) orelse {
                return error.ExpectedBinding;
            };
            instance_args[i] = try bound_type.clone(alloc);
        }

        const dst: TypedOperand = .{
            .operand = ir_builder.nextTemp(),
            .type = .{
                .instance = .{
                    .class_id = class.id,
                    .args = instance_args,
                },
            },
        };
        try ir_builder.emit(.{ .class_init = .{
            .dst = dst,
            .class_id = class.id,
            .args = try arguments.toOwnedSlice(alloc),
        } }, alloc);
        return try dst.clone(alloc);
    }

    std.debug.print("cant find function {s}\n", .{name});
    return error.CantFindFunction;
}

// Call(func=Attribute(value=Name(id='audi', ctx=Load()), attr='print_speed', ctx=Load()))
fn walkMethodCall(stmt: *PyObject, func: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) anyerror!TypedOperand {
    const instance_obj = c.PyObject_GetAttrString(func, "value");
    std.debug.assert(instance_obj != null);

    const method_obj = c.PyObject_GetAttrString(func, "attr");
    std.debug.assert(method_obj != null);
    const method_name_raw = c.PyUnicode_AsUTF8(method_obj);
    std.debug.assert(method_name_raw != null);
    const method_name = std.mem.span(method_name_raw);

    var self: ?TypedOperand = null;
    const method = blk: {
        // super().method
        if (std.mem.eql(u8, getPyType(instance_obj), "Call")) {
            const super_func_obj = c.PyObject_GetAttrString(instance_obj, "func");
            std.debug.assert(super_func_obj != null);
            if (std.mem.eql(u8, getPyType(super_func_obj), "Name")) {
                const id_obj = PyObject.GetAttrString(super_func_obj, "id");
                std.debug.assert(id_obj != null);
                const raw_name = c.PyUnicode_AsUTF8(id_obj);
                std.debug.assert(raw_name != null);
                const name = std.mem.span(raw_name);
                if (std.mem.eql(u8, name, "super")) {
                    const super_args = c.PyObject_GetAttrString(instance_obj, "args");
                    std.debug.assert(super_args != null);
                    if (c.PyList_Size(super_args) != 0) {
                        std.debug.print("super must have 0 args but found\n", .{});
                        return error.InvalidSuperCall;
                    }
                    const current_class = ir_builder.current_class orelse {
                        return error.CurrentClassNotSet;
                    };
                    const base_class_id = ir_builder.getClass(current_class).base_class orelse {
                        return error.CurrentClassMissingBase;
                    };
                    const base_class = ir_builder.getClass(base_class_id);
                    const method_info = base_class.findMethod(method_name) orelse {
                        return error.CantFindMethod;
                    };
                    if (method_info.is_static) return error.ExpectedInstance;
                    const method = ir_builder.getFunction(method_info.function_id) orelse {
                        return error.CantFindFunction;
                    };
                    // establish self
                    const self_name = ir_builder.currentFunction().params[0].name;
                    const self_id = try ir_builder.getLocal(self_name);
                    const self_value = ir_builder.current_scope.local_values.map.get(self_id) orelse {
                        return error.CantFindSelf;
                    };
                    self = try self_value.clone(alloc);

                    break :blk method;
                }
            }
        } else if (std.mem.eql(u8, getPyType(instance_obj), "Name")) {
            const id_obj = PyObject.GetAttrString(instance_obj, "id");
            std.debug.assert(id_obj != null);
            const raw_name = c.PyUnicode_AsUTF8(id_obj);
            std.debug.assert(raw_name != null);
            const name = std.mem.span(raw_name);
            if (ir_builder.findClass(name)) |class| {
                const method_info = class.findMethod(method_name) orelse {
                    return error.CantFindMethod;
                };
                if (!method_info.is_static) return error.ExpectedInstance;
                const method = ir_builder.getFunction(method_info.function_id) orelse {
                    return error.CantFindFunction;
                };
                break :blk method;
            }
        }
        var receiver_expr: ?TypedOperand = try walkExpr(instance_obj, ir_builder, null, alloc);
        errdefer if (receiver_expr) |*value| value.deinit(alloc);
        const method = switch (receiver_expr.?.type) {
            .instance => |inst| module_blk: {
                self = receiver_expr.?;
                receiver_expr = null;
                const class = ir_builder.getClass(inst.class_id);
                const method_info = class.findMethod(method_name) orelse {
                    std.debug.print("cant find method {s}\n", .{method_name});
                    return error.CantFindMethod;
                };
                break :module_blk ir_builder.getFunction(method_info.function_id) orelse {
                    return error.CantFindFunction;
                };
            },
            .module => |module_id| {
                break :blk ir_builder.getModuleFunction(module_id, method_name) orelse {
                    return error.CantFindFunction;
                };
            },
            else => return error.ExpectedInstance,
        };
        break :blk method;
    };

    var arguments: ArrayList(TypedOperand) = .empty;
    errdefer {
        for (arguments.items) |arg| {
            arg.type.deinit(alloc);
        }
        arguments.deinit(alloc);
    }

    // instance expression, <remaining args>
    if (self) |value| {
        try arguments.append(alloc, value);
    }
    const args_obj = c.PyObject_GetAttrString(stmt, "args");
    std.debug.assert(args_obj != null);
    for (0..@intCast(c.PyList_Size(args_obj))) |i| {
        const arg_obj = c.PyList_GetItem(args_obj, @intCast(i));
        std.debug.assert(arg_obj != null);
        const arg = try walkExpr(arg_obj, ir_builder, null, alloc);
        try arguments.append(alloc, arg);
    }

    return emitResolvedCall(method, &arguments, ir_builder, alloc);
}

// Subscript(value=Name(id='MiniTorch', ctx=Load()), slice=Name(id='int', ctx=Load()), ctx=Load())
fn walkGenericCall(stmt: *PyObject, func: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) anyerror!TypedOperand {
    const value = PyObject.GetAttrString(func, "value");
    std.debug.assert(value != null);

    if (!std.mem.eql(u8, getPyType(value), "Name")) {
        return error.UnsupportedGenericCall;
    }
    const name_obj = PyObject.GetAttrString(value, "id");
    std.debug.assert(name_obj != null);
    const raw_name = PyObject.PyUnicode_AsUTF8(name_obj);
    std.debug.assert(raw_name != null);
    const name = std.mem.span(raw_name);

    const class = ir_builder.findClass(name) orelse {
        return error.CantFindClass;
    };

    const slice_obj = PyObject.GetAttrString(func, "slice");
    std.debug.assert(slice_obj != null);

    var type_args: ArrayList(TypeInfo) = .empty;
    errdefer {
        for (type_args.items) |arg| {
            arg.deinit(alloc);
        }
        type_args.deinit(alloc);
    }

    try type_args.append(
        alloc,
        try parseTypeAnnotation(slice_obj, ir_builder, alloc),
    );

    if (type_args.items.len != class.type_params.len) {
        return error.InvalidTypeArgumentCount;
    }

    const args_list = c.PyObject_GetAttrString(stmt, "args");
    std.debug.assert(args_list != null);
    var arguments: ArrayList(TypedOperand) = .empty;
    errdefer {
        for (arguments.items) |arg| {
            arg.deinit(alloc);
        }
        arguments.deinit(alloc);
    }
    for (0..@intCast(c.PyList_Size(args_list))) |i| {
        const arg_obj = c.PyList_GetItem(args_list, @intCast(i));
        std.debug.assert(arg_obj != null);
        const arg = try walkExpr(arg_obj, ir_builder, null, alloc);
        try arguments.append(alloc, arg);
    }

    const dst: TypedOperand = .{
        .operand = ir_builder.nextTemp(),
        .type = .{ .instance = .{
            .class_id = class.id,
            .args = try type_args.toOwnedSlice(alloc),
        } },
    };

    try ir_builder.emit(.{ .class_init = .{
        .dst = dst,
        .args = try arguments.toOwnedSlice(alloc),
        .class_id = class.id,
    } }, alloc);

    return try dst.clone(alloc);
}

// If(test=Compare(...), body=[...], orelse=[...])
pub fn walkIf(stmt: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) anyerror!void {
    var before_values = try ir_builder.current_scope.local_values.clone(alloc);
    defer before_values.deinit(alloc);

    const test_ = c.PyObject_GetAttrString(stmt, "test");
    const body = c.PyObject_GetAttrString(stmt, "body");
    const orelse_ = c.PyObject_GetAttrString(stmt, "orelse");

    const then_block = try ir_builder.newBlock(alloc);
    const else_block = try ir_builder.newBlock(alloc);
    const merge_block = try ir_builder.newBlock(alloc);

    const condition = try walkExpr(test_, ir_builder, null, alloc);
    try ir_builder.emit(.{ .lir = .{ .branch = .{
        .condition = condition,
        .then_block = then_block,
        .else_block = else_block,
    } } }, alloc);
    try ir_builder.addSuccessor(ir_builder.current_block, then_block, alloc);
    try ir_builder.addSuccessor(ir_builder.current_block, else_block, alloc);

    // then block
    ir_builder.setCurrentBlock(then_block);
    // restore in case condition set variables
    try ir_builder.current_scope.restoreLocalValues(&before_values, alloc);
    try walkStmtList(body, ir_builder, alloc);
    const then_exit_block = ir_builder.current_block;
    // save then locals
    var then_values = try ir_builder.current_scope.local_values.clone(alloc);
    defer then_values.deinit(alloc);
    try ir_builder.emit(.{ .lir = .{
        .jump = .{ .target = merge_block },
    } }, alloc);
    try ir_builder.addSuccessor(then_exit_block, merge_block, alloc);

    // else block
    ir_builder.setCurrentBlock(else_block);
    // restore in case condition set variables
    try ir_builder.current_scope.restoreLocalValues(&before_values, alloc);
    try walkStmtList(orelse_, ir_builder, alloc);
    // save else locals
    const else_exit_block = ir_builder.current_block;
    var else_values = try ir_builder.current_scope.local_values.clone(alloc);
    defer else_values.deinit(alloc);
    try ir_builder.emit(.{ .lir = .{
        .jump = .{ .target = merge_block },
    } }, alloc);
    try ir_builder.addSuccessor(else_exit_block, merge_block, alloc);

    ir_builder.setCurrentBlock(merge_block);
    // get locals orelse use branch value
    ir_builder.current_scope.local_values.clear(alloc);
    var all_locals: std.AutoHashMap(LocalId, void) = .init(alloc);
    defer all_locals.deinit();

    var before_it = before_values.map.keyIterator();
    while (before_it.next()) |val| {
        try all_locals.put(val.*, {});
    }

    var then_it = then_values.map.keyIterator();
    while (then_it.next()) |val| {
        try all_locals.put(val.*, {});
    }

    var else_it = else_values.map.keyIterator();
    while (else_it.next()) |val| {
        try all_locals.put(val.*, {});
    }

    var it = all_locals.keyIterator();
    while (it.next()) |local| {
        const before_value = before_values.map.get(local.*);
        const then_value = then_values.map.get(local.*) orelse before_value;
        const else_value = else_values.map.get(local.*) orelse before_value;

        const has_before = before_value != null;
        const has_then = then_value != null;
        const has_else = else_value != null;
        // variable isn't touch so no need to use a phi
        if (has_then and has_else and then_value.?.equal(else_value.?)) {
            try ir_builder.current_scope.local_values.map.put(local.*, try before_value.?.clone(alloc));
        }
        // emit a phi
        else if (has_then and has_else) {
            const dst = ir_builder.nextTemp();
            const inputs = try alloc.dupe(PhiInput, &.{
                .{ .pred = then_exit_block, .value = try then_value.?.clone(alloc) },
                .{ .pred = else_exit_block, .value = try else_value.?.clone(alloc) },
            });

            const typed_dst: TypedOperand = .{
                .operand = dst,
                .type = try then_value.?.type.clone(alloc),
            };
            try ir_builder.emit(.{
                .phi = .{ .dst = typed_dst, .inputs = inputs },
            }, alloc);
            try ir_builder.current_scope.local_values.map.put(local.*, try typed_dst.clone(alloc));
        } else if (!has_before and ((has_then and !has_else) or (!has_then and has_else))) {
            continue;
        } else {
            return error.NotImplemented;
        }
    }
}

//              ------------
//              |          |
//              v          |
// entry -> condition -> body
//              |
//              v
//             exit
// While(test=Compare(...), body=[...], orelse=[...])
pub fn walkWhile(stmt: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) anyerror!void {
    const test_ = c.PyObject_GetAttrString(stmt, "test");
    const body = c.PyObject_GetAttrString(stmt, "body");
    const orelse_ = c.PyObject_GetAttrString(stmt, "orelse");
    std.debug.assert(test_ != null);
    std.debug.assert(body != null);
    std.debug.assert(orelse_ != null);

    const callback = struct {
        fn loop(input_body: LoopBody, carries: []LoopCarry, ir_builder_: *IrBuilder, alloc_: std.mem.Allocator) anyerror!void {
            _ = carries;
            const body_ = switch (input_body) {
                .stmt_list => |sl| sl,
                else => return error.BadState,
            };
            try walkStmtList(body_, ir_builder_, alloc_);
        }
    };

    try walkLoop(ir_builder, .{ .expr = test_ }, LoopBody{ .stmt_list = body }, &.{}, callback.loop, orelse_, alloc);
}

// arr = [...] # range
// len = len(arr)
// index0 = 0
//
// condition:
//   index = phi(entry: index0, body: index_next)
//   keep_going = (index < len)
//   branch keep_going body exit
//
// body:
//   value = arr[index]
//   body
//   index_next = index + 1
//   jump condition
//
// exit:
pub fn walkFor(stmt: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) anyerror!void {
    const target = c.PyObject_GetAttrString(stmt, "target");
    std.debug.assert(target != null);
    const target_name_obj = c.PyObject_GetAttrString(target, "id");
    std.debug.assert(target_name_obj != null);
    const target_name_raw = c.PyUnicode_AsUTF8(target_name_obj);
    std.debug.assert(target_name_raw != null);
    const target_name = std.mem.span(target_name_raw);

    const iter = c.PyObject_GetAttrString(stmt, "iter");
    std.debug.assert(iter != null);

    const expr = try walkExpr(iter, ir_builder, null, alloc);
    std.debug.assert(expr.type.isIterable());

    const index0: TypedOperand = .{
        .operand = ir_builder.nextTemp(),
        .type = try expr.type.getElementType(),
    };
    const zero: ConstValue = switch (index0.type) {
        .i64 => .{ .i64 = 0 },
        .i32 => .{ .i32 = 0 },
        else => return error.InvalidRange,
    };
    try ir_builder.emit(.{ .lir = .{ .move = .{
        .dst = index0,
        .src = .{ .constant = zero },
    } } }, alloc);

    const callback = struct {
        fn loop(input_body_: LoopBody, carries: []LoopCarry, ir_builder_: *IrBuilder, alloc_: std.mem.Allocator) anyerror!void {
            const body_ = switch (input_body_) {
                .for_loop => |fl| fl,
                else => return error.BadState,
            };
            // value = arr[index]
            const index = carries[0].current;
            const value = ir_builder_.nextTemp();
            const iterable = if (body_.iterator_local) |local|
                ir_builder_.current_scope.local_values.map.get(local) orelse return error.NotFound
            else
                body_.iterator;
            switch (iterable.type) {
                .tuple => {
                    try ir_builder_.emit(.{ .subscript = .{
                        .dst = .{ .operand = value, .type = .any },
                        .src = try iterable.clone(alloc_),
                        .index = try index.clone(alloc_),
                    } }, alloc_);
                },
                .list => {
                    try ir_builder_.emit(.{ .subscript = .{
                        .dst = .{ .operand = value, .type = .any },
                        .src = try iterable.clone(alloc_),
                        .index = try index.clone(alloc_),
                    } }, alloc_);
                },
                .iterable => {
                    try ir_builder_.emit(.{ .subscript = .{
                        .dst = .{ .operand = value, .type = .any },
                        .src = try iterable.clone(alloc_),
                        .index = try index.clone(alloc_),
                    } }, alloc_);
                },
                .lazy => {
                    try ir_builder_.emit(.{ .subscript = .{
                        .dst = .{ .operand = value, .type = try iterable.type.getElementType() },
                        .src = try iterable.clone(alloc_),
                        .index = try index.clone(alloc_),
                    } }, alloc_);
                },
                else => return error.CantIndexInto,
            }

            const elem_type = try iterable.type.getElementType();
            const local = try ir_builder_.current_scope.getOrCreateLocal(
                body_.condition_var_name,
                try elem_type.clone(alloc_),
                alloc_,
            );
            const typed_value: TypedOperand = .{
                .operand = value,
                .type = elem_type,
            };
            try ir_builder_.current_scope.local_values.map.put(local, typed_value);
            try ir_builder_.emit(.{ .lir = .{ .store_local = .{
                .local = .{
                    .id = local,
                    .name = try alloc_.dupe(u8, body_.condition_var_name),
                    .type = try elem_type.clone(alloc_),
                },
                .src = typed_value,
            } } }, alloc_);

            try walkStmtList(body_.stmt_list, ir_builder_, alloc_);
            // index += 1
            const one: TypedOperand = .{
                .operand = ir_builder_.nextTemp(),
                .type = try index.type.clone(alloc_),
            };
            const one_value: ConstValue = switch (one.type) {
                .i64 => .{ .i64 = 1 },
                .i32 => .{ .i32 = 1 },
                else => return error.InvalidRange,
            };
            try ir_builder_.emit(.{ .lir = .{ .move = .{
                .dst = one,
                .src = .{ .constant = one_value },
            } } }, alloc_);

            const index_next: TypedOperand = .{
                .operand = ir_builder_.nextTemp(),
                .type = try index.type.clone(alloc_),
            };
            try ir_builder_.emit(.{ .lir = .{ .binop = .{
                .dst = index_next,
                .lhs = index,
                .op = .add,
                .rhs = try one.clone(alloc_),
            } } }, alloc_);
            carries[0].next = index_next;
        }
    };

    const body = c.PyObject_GetAttrString(stmt, "body");
    var carries: ArrayList(LoopCarry) = .empty;
    defer carries.deinit(alloc);
    try carries.append(alloc, .{
        .initial = try index0.clone(alloc),
        .current = undefined,
        .next = null,
        .inputs = undefined,
    });

    const len_temp: TypedOperand = .{
        .operand = ir_builder.nextTemp(),
        .type = try index0.type.clone(alloc),
    };

    std.debug.assert(expr.type.isIterable());
    try ir_builder.emit(.{ .len = .{
        .dst = len_temp,
        .value = expr,
    } }, alloc);

    // set for j in jj where type(jj) == array
    const iterator_local: ?LocalId = if (getExprKind(iter) == .Name) blk: {
        const id_obj = c.PyObject_GetAttrString(iter, "id");
        std.debug.assert(id_obj != null);

        const id = c.PyUnicode_AsUTF8(id_obj);
        std.debug.assert(id != null);

        break :blk try ir_builder.current_scope.getOrCreateLocal(std.mem.span(id), null, alloc);
    } else null;

    try walkLoop(
        ir_builder,
        .{ .operand_compare = .{
            .carry_index = 0,
            .cmp = .lt,
            .rhs = len_temp,
        } },
        .{ .for_loop = .{
            .stmt_list = body,
            .condition_var_name = target_name,
            .iterator = expr,
            .iterator_local = iterator_local,
        } },
        carries.items,
        callback.loop,
        null,
        alloc,
    );
}

// module declares the function
fn walkFuncDef(stmt: *PyObject, ir_builder: *IrBuilder, class_id: ?ClassId, alloc: std.mem.Allocator) anyerror!void {
    // set and restore current class
    const saved_class = ir_builder.current_class;
    ir_builder.current_class = class_id;
    defer ir_builder.current_class = saved_class;
    // start walking function
    const func_name_obj = c.PyObject_GetAttrString(stmt, "name");
    std.debug.assert(func_name_obj != null);
    const raw_func_name = c.PyUnicode_AsUTF8(func_name_obj);
    std.debug.assert(raw_func_name != null);
    const func_name = std.mem.span(raw_func_name);

    // append class name onto its methods
    const definition_name = if (class_id) |id| blk: {
        const class = ir_builder.getClass(id);
        const name = try std.fmt.allocPrint(alloc, "{s}__{s}", .{ class.name, func_name });
        break :blk name;
    } else func_name;
    defer if (class_id != null) alloc.free(definition_name);

    // save function state
    const saved_current_function = ir_builder.current_function;
    const saved_current_block = ir_builder.current_block;
    var saved_local_values = try ir_builder.current_scope.local_values.clone(alloc);
    defer saved_local_values.deinit(alloc);

    // set function state
    const declared = ir_builder.getModuleFunction(ir_builder.current_module_id, definition_name) orelse {
        std.debug.print("cant find function {s}\n", .{definition_name});
        return error.FunctionNotDeclared;
    };
    const saved_type_params = ir_builder.active_param_types;
    ir_builder.active_param_types = declared.type_params;
    defer ir_builder.active_param_types = saved_type_params;
    // restore state
    ir_builder.current_function = declared.id - 1;
    ir_builder.current_block = 0;
    ir_builder.current_scope.local_values.clear(alloc);

    // load function params
    const function = ir_builder.currentFunction();
    for (function.params, 0..) |param, i| {
        const value: TypedOperand = .{
            .operand = ir_builder.nextTemp(),
            .type = try param.type.clone(alloc),
        };

        try ir_builder.emit(.{ .function_param = .{
            .dst = try value.clone(alloc),
            .name = try alloc.dupe(u8, param.name),
            .index = i,
        } }, alloc);

        const local = try ir_builder.current_scope.getOrCreateLocal(
            param.name,
            param.type,
            alloc,
        );
        try ir_builder.current_scope.local_values.map.put(local, value);
    }

    const body = c.PyObject_GetAttrString(stmt, "body");
    std.debug.assert(body != null);
    try walkStmtList(body, ir_builder, alloc);

    // append return if we are missing one
    const block = ir_builder.currentBlock();
    const termianted = block.instructions.items.len > 0 and switch (block.instructions.items[block.instructions.items.len - 1]) {
        .function_return => true,
        .lir => |lir| switch (lir) {
            .jump, .branch => true,
            else => false,
        },
        else => false,
    };
    if (!termianted and function.return_type == .void) {
        try ir_builder.emit(.{ .function_return = .{ .value = null } }, alloc);
    }

    // restore function state
    ir_builder.current_function = saved_current_function;
    ir_builder.current_block = saved_current_block;
    try ir_builder.current_scope.restoreLocalValues(&saved_local_values, alloc);
}

fn emitResolvedCall(
    function: *const Function,
    arguments: *ArrayList(TypedOperand),
    ir_builder: *IrBuilder,
    alloc: std.mem.Allocator,
) !TypedOperand {
    if (function.kind == .gpu_kernel) {
        if (arguments.items.len != function.params.len + 1) {
            return error.InvalidGpuLaunchArgs;
        }
        const work_item_index = arguments.items.len - 1;
        const work_items = try arguments.items[work_item_index].clone(alloc);
        arguments.items[work_item_index].deinit(alloc);
        arguments.items.len = work_item_index;

        const gpu_args = try arguments.toOwnedSlice(alloc);
        try ir_builder.emit(.{
            .gpu_launch = .{
                .kernel = try alloc.dupe(u8, function.label),
                .args = gpu_args,
                .work_items = work_items,
            },
        }, alloc);
        return TypedOperand{ .operand = .unknown, .type = .void };
    }
    var bindings: TypeBindings = .init(alloc);
    defer bindings.deinit(alloc);
    const return_type = try bindings.inferReturnType(function, arguments.items, alloc);

    const maybe_dst: ?TypedOperand = if (function.return_type != .void)
        .{
            .operand = ir_builder.nextTemp(),
            .type = return_type,
        }
    else
        null;
    try ir_builder.emit(.{
        .function_call = .{
            .callee = .{ .direct = try alloc.dupe(u8, function.label) },
            .dst = maybe_dst,
            .args = try arguments.toOwnedSlice(alloc),
        },
    }, alloc);

    if (maybe_dst) |dst| return try dst.clone(alloc);
    return .{ .operand = .unknown, .type = .void };
}

// Return(value=BinOp(left=Name(id='x', ctx=Load()), op=Add(), right=Name(id='y', ctx=Load())))
// Return()
fn walkReturn(stmt: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) !void {
    const value = c.PyObject_GetAttrString(stmt, "value");
    std.debug.assert(value != null);
    const return_top = if (value == c.Py_None())
        null
    else
        try walkExpr(value, ir_builder, null, alloc);

    try ir_builder.emit(.{ .function_return = .{
        .value = return_top,
    } }, alloc);
}

fn getBinOp(expr: *PyObject) !BinOp {
    const op_obj = c.PyObject_GetAttrString(expr, "op");
    std.debug.assert(op_obj != null);
    const name = getPyType(op_obj);

    if (std.mem.eql(u8, name, "Add")) return .add;
    if (std.mem.eql(u8, name, "Sub")) return .sub;
    if (std.mem.eql(u8, name, "Mult")) return .mul;
    if (std.mem.eql(u8, name, "Div")) return .div;
    if (std.mem.eql(u8, name, "FloorDiv")) return .floor_div;
    if (std.mem.eql(u8, name, "Mod")) return .mod;
    if (std.mem.eql(u8, name, "LShift")) return .lshift;
    if (std.mem.eql(u8, name, "RShift")) return .rshift;
    if (std.mem.eql(u8, name, "MatMult")) return .matmul;

    std.debug.panic("unsupported binop: {s}", .{name});
    return error.NotFound;
}

fn getUnaryOp(expr: *PyObject) !UnaryOp {
    const op_obj = c.PyObject_GetAttrString(expr, "op");
    std.debug.assert(op_obj != null);
    const name = getPyType(op_obj);

    if (std.mem.eql(u8, name, "USub")) return .neg;

    std.debug.panic("unsupported unaryop: {s}", .{name});
    return error.NotFound;
}

fn getCompareOp(expr: *PyObject) !CmpOp {
    const ops = c.PyObject_GetAttrString(expr, "ops");
    std.debug.assert(ops != null);
    const ops_obj = c.PyList_GetItem(ops, 0);
    std.debug.assert(ops_obj != null);

    const name = getPyType(ops_obj);

    if (std.mem.eql(u8, name, "Eq")) return .eq;
    if (std.mem.eql(u8, name, "NotEq")) return .neq;
    if (std.mem.eql(u8, name, "Lt")) return .lt;
    if (std.mem.eql(u8, name, "LtE")) return .lte;
    if (std.mem.eql(u8, name, "Gt")) return .gt;
    if (std.mem.eql(u8, name, "GtE")) return .gte;

    std.debug.panic("unsupported compare op: {s}", .{name});
    return error.NotFound;
}

fn getExprKind(stmt: *PyObject) ExprKind {
    const name = getPyType(stmt);
    if (std.mem.eql(u8, name, "BinOp")) return .BinOp;
    if (std.mem.eql(u8, name, "Compare")) return .Compare;
    if (std.mem.eql(u8, name, "UnaryOp")) return .UnaryOp;
    if (std.mem.eql(u8, name, "Constant")) return .Constant;
    if (std.mem.eql(u8, name, "Name")) return .Name;
    if (std.mem.eql(u8, name, "Call")) return .Call;
    if (std.mem.eql(u8, name, "List")) return .List;
    if (std.mem.eql(u8, name, "Tuple")) return .Tuple;
    if (std.mem.eql(u8, name, "Subscript")) return .Subscript;
    if (std.mem.eql(u8, name, "IfExp")) return .IfExp;
    if (std.mem.eql(u8, name, "Attribute")) return .Attribute;
    if (std.mem.eql(u8, name, "BoolOp")) return .BoolOp;
    if (std.mem.eql(u8, name, "JoinedStr")) return .FString;
    if (std.mem.eql(u8, name, "Lambda")) return .Lambda;
    return .Unknown;
}

fn getBuiltinCall(name: []const u8) ?BuiltinCall {
    if (std.mem.eql(u8, name, "range")) return .Range;
    if (std.mem.eql(u8, name, "print")) return .Print;
    if (std.mem.eql(u8, name, "write")) return .Write;
    if (std.mem.eql(u8, name, "len")) return .Len;
    if (std.mem.eql(u8, name, "int")) return .Int;
    if (std.mem.eql(u8, name, "i32")) return .I32;
    if (std.mem.eql(u8, name, "float")) return .Float;
    if (std.mem.eql(u8, name, "f32")) return .F32;
    if (std.mem.eql(u8, name, "global_id")) return .GlobalIdx;
    if (std.mem.eql(u8, name, "max")) return .Max;
    if (std.mem.eql(u8, name, "exp")) return .Exp;
    if (std.mem.eql(u8, name, "exp2")) return .Exp2;
    if (std.mem.eql(u8, name, "type")) return .Type;
    return null;
}

fn getBoolOp(name: []const u8) !BoolOp {
    if (std.mem.eql(u8, name, "And")) return .And;
    std.debug.print("cant handle bool op {s}\n", .{name});
    return error.UnsupportedBoolOp;
}

test "while loop" {
    c.Py_Initialize();
    defer _ = c.Py_FinalizeEx();

    const alloc = std.testing.allocator;
    const code: [*:0]const u8 =
        \\x = 0
        \\while x < 3:
        \\  x = x + 1
        \\  print(x)
        \\print(x)
    ;

    const ast_module = c.PyImport_ImportModule("ast");
    const parse_fn = c.PyObject_GetAttrString(ast_module, "parse");
    const tree = c.PyObject_CallFunction(parse_fn, "s", code);
    std.debug.assert(tree != null);

    var ir_builder: IrBuilder = try .init(.user, 0, "__init__", alloc);
    defer ir_builder.deinit(alloc);
    errdefer ir_builder.program.deinit(alloc);
    try walkAstIntoBuilder(tree, &ir_builder, alloc);
    var program = ir_builder.program;
    defer program.deinit(alloc);

    try std.testing.expectEqual(@as(usize, 4), program.main.blocks.items.len);

    const entry = program.main.blocks.items[0].instructions.items;
    const condition = program.main.blocks.items[1].instructions.items;
    const body = program.main.blocks.items[2].instructions.items;
    const exit = program.main.blocks.items[3].instructions.items;

    try std.testing.expectEqualDeep(
        Instruction{ .lir = .{ .move = .{
            .dst = .{ .operand = .{ .temp = .{ .id = 0, .function_id = 0 } }, .type = .i64 },
            .src = .{ .constant = .{ .i64 = 0 } },
        } } },
        entry[0],
    );
    try std.testing.expectEqualDeep(
        Instruction{
            .lir = .{ .store_local = .{ .local = .{
                .id = 0,
                .name = "x",
                .type = .i64,
            }, .src = .{
                .operand = .{ .temp = .{ .id = 0, .function_id = 0 } },
                .type = .i64,
            } } },
        },
        entry[1],
    );
    try std.testing.expectEqualDeep(
        Instruction{ .lir = .{ .jump = .{ .target = 1 } } },
        entry[2],
    );

    switch (condition[0]) {
        .phi => {
            // temp1 = phi(entry: temp0, body: temp4)
        },
        else => return error.ExpectedPhi,
    }

    try std.testing.expectEqual(.lir, std.meta.activeTag(body[1]));
    switch (body[1].lir) {
        .binop => {},
        else => return error.ExpectedBinOp,
    }

    switch (exit[0]) {
        .print => {},
        else => return error.ExpectedPrint,
    }
}
