const std = @import("std");
const ArrayList = std.ArrayList;
const IrBuilder = @import("ir_builder.zig").IrBuilder;
const ClassInfo = @import("common").ir.ClassInfo;
const ClassId = @import("common").ir.ClassId;
const TypeParam = @import("common").ir.TypeParam;
const TypeInfo = @import("common").types.TypeInfo;
const Param = @import("common").ir.Param;
const ParsedConstant = @import("common").ir.ParsedConstant;
const Function = @import("common").ir.Function;
const FunctionKind = @import("common").ir.FunctionKind;
const ConstValue = @import("common").ir.ConstValue;
const ValueRef = @import("common").ir.ValueRef;

pub const c = @cImport({
    @cInclude("Python.h");
});
pub const PyObject = c.PyObject;

pub const SubscriberTypes = union(enum) {
    list,
    tuple,
    callable,
    instance: ClassId,
};

pub const StmtKind = enum {
    Assign,
    AnnotatedAssign,
    Expr,
    If,
    While,
    For,
    FuncDef,
    Return,
    Pass,
    Import,
    ImportFrom,
    AugAssign,
    ClassDef,
    Unknown,
};

pub fn getPyType(stmt: *PyObject) []const u8 {
    const _type = c.PyObject_Type(stmt);
    const name_ptr = c.PyObject_GetAttrString(_type, "__name__");
    return std.mem.span(c.PyUnicode_AsUTF8(name_ptr));
}

pub fn getStmtKind(stmt: *PyObject) StmtKind {
    const name = getPyType(stmt);

    if (std.mem.eql(u8, name, "Assign")) return .Assign;
    if (std.mem.eql(u8, name, "Expr")) return .Expr;
    if (std.mem.eql(u8, name, "If")) return .If;
    if (std.mem.eql(u8, name, "While")) return .While;
    if (std.mem.eql(u8, name, "For")) return .For;
    if (std.mem.eql(u8, name, "AnnAssign")) return .AnnotatedAssign;
    if (std.mem.eql(u8, name, "FunctionDef")) return .FuncDef;
    if (std.mem.eql(u8, name, "Return")) return .Return;
    if (std.mem.eql(u8, name, "Pass")) return .Pass;
    if (std.mem.eql(u8, name, "Import")) return .Import;
    if (std.mem.eql(u8, name, "ImportFrom")) return .ImportFrom;
    if (std.mem.eql(u8, name, "AugAssign")) return .AugAssign;
    if (std.mem.eql(u8, name, "ClassDef")) return .ClassDef;
    return .Unknown;
}

pub fn printAstDump(node: *PyObject) void {
    const ast_module = c.PyImport_ImportModule("ast");
    std.debug.assert(ast_module != null);

    const dump_fn = c.PyObject_GetAttrString(ast_module, "dump");
    std.debug.assert(dump_fn != null);

    const dumped_obj = c.PyObject_CallFunction(dump_fn, "O", node);
    std.debug.assert(dumped_obj != null);

    const dumped = c.PyUnicode_AsUTF8(dumped_obj);
    std.debug.assert(dumped != null);

    std.debug.print("{s}\n", .{dumped});
}

pub fn declareClassesInAst(ast: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) !void {
    const body = c.PyObject_GetAttrString(ast, "body");
    std.debug.assert(body != null);

    for (0..@intCast(c.PyList_Size(body))) |i| {
        const stmt = c.PyList_GetItem(body, @intCast(i));
        std.debug.assert(stmt != null);
        switch (getStmtKind(stmt)) {
            .ClassDef => try declareClass(stmt, ir_builder, alloc),
            else => {},
        }
    }
}

pub fn declareFunctionsInAst(ast: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) !void {
    const body = c.PyObject_GetAttrString(ast, "body");
    std.debug.assert(body != null);

    for (0..@intCast(c.PyList_Size(body))) |i| {
        const stmt = c.PyList_GetItem(body, @intCast(i));
        std.debug.assert(stmt != null);
        switch (getStmtKind(stmt)) {
            .FuncDef => try declareFuncDef(stmt, ir_builder, null, alloc),
            .ClassDef => {
                const name_obj = c.PyObject_GetAttrString(stmt, "name");
                std.debug.assert(name_obj != null);
                const name = std.mem.span(c.PyUnicode_AsUTF8(name_obj));

                const class_id = (ir_builder.findClass(name) orelse {
                    return error.ClassNotDeclared;
                }).id;

                const class_body = c.PyObject_GetAttrString(stmt, "body");
                std.debug.assert(class_body != null);
                for (0..@intCast(c.PyList_Size(class_body))) |j| {
                    const method = c.PyList_GetItem(class_body, @intCast(j));
                    std.debug.assert(method != null);
                    if (getStmtKind(method) == .FuncDef) {
                        try declareFuncDef(method, ir_builder, class_id, alloc);
                    }
                }
            },
            else => {},
        }
    }
}

fn declareClass(stmt: *PyObject, ir_builder: *IrBuilder, alloc: std.mem.Allocator) !void {
    const name_obj = c.PyObject_GetAttrString(stmt, "name");
    std.debug.assert(name_obj != null);
    const raw_name = c.PyUnicode_AsUTF8(name_obj);
    std.debug.assert(raw_name != null);
    const name = std.mem.span(raw_name);

    const id: ClassId = ir_builder.nextClassIdx();
    const class_type_params = try parseTypeParams(stmt, 0, alloc);

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
    const class_info = try ClassInfo.init(id, name, class_type_params, base_class_id, alloc);
    try ir_builder.program.classes.append(
        alloc,
        class_info,
    );
}

fn declareFuncDef(stmt: *PyObject, ir_builder: *IrBuilder, class_id: ?ClassId, alloc: std.mem.Allocator) !void {
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
    const args_obj = c.PyObject_GetAttrString(stmt, "args");
    std.debug.assert(args_obj != null);
    const args_list = c.PyObject_GetAttrString(args_obj, "args");
    std.debug.assert(args_list != null);
    // std.debug.print(
    //     "walk function {s} from module {s}\n",
    //     .{ func_name, irBuilder.current_module_name },
    // );

    const is_static = try hasDecorator(stmt, "staticmethod");
    // type params (generics)
    var type_params: ArrayList(TypeParam) = .empty;
    errdefer {
        for (type_params.items) |*t_param| {
            t_param.deinit(alloc);
        }
        type_params.deinit(alloc);
    }
    if (class_id) |id| {
        if (!is_static) {
            const class = ir_builder.getClass(id);

            for (class.type_params) |*type_param| {
                try type_params.append(alloc, try type_param.clone(alloc));
            }
        }
    }

    const function_type_params = try parseTypeParams(stmt, @intCast(type_params.items.len), alloc);
    defer alloc.free(function_type_params);
    try type_params.appendSlice(alloc, function_type_params);

    const saved_type_params = ir_builder.active_param_types;
    ir_builder.active_param_types = type_params.items;
    defer ir_builder.active_param_types = saved_type_params;

    // function params
    var params: ArrayList(Param) = .empty;
    errdefer {
        for (params.items) |*param| {
            param.deinit(alloc);
        }
        params.deinit(alloc);
    }
    // iterate through args
    for (0..@intCast(c.PyList_Size(args_list))) |i| {
        const arg_obj = c.PyList_GetItem(args_list, @intCast(i));
        std.debug.assert(arg_obj != null);

        const arg_obj_name = c.PyObject_GetAttrString(arg_obj, "arg");
        std.debug.assert(arg_obj_name != null);
        const annotation = c.PyObject_GetAttrString(arg_obj, "annotation");
        std.debug.assert(annotation != null);

        // only param 0 for classes becomes instance
        const arg_type: TypeInfo = if (class_id == null or is_static or i != 0)
            try parseTypeAnnotation(annotation, ir_builder, alloc)
        else instance: {
            const class = ir_builder.getClass(class_id.?);
            const instance_args = try alloc.alloc(TypeInfo, class.type_params.len);

            for (class.type_params, 0..) |type_param, type_i| {
                instance_args[type_i] = .{
                    .type_variable = type_param.id,
                };
            }
            break :instance .{ .instance = .{
                .class_id = class_id.?,
                .args = instance_args,
            } };
        };
        const raw_name = c.PyUnicode_AsUTF8(arg_obj_name);
        std.debug.assert(raw_name != null);
        const name = std.mem.span(raw_name);

        try params.append(alloc, .{
            .name = try alloc.dupe(u8, name),
            .type = arg_type,
        });
    }
    // default function params
    const default_objs = c.PyObject_GetAttrString(args_obj, "defaults");
    std.debug.assert(default_objs != null);
    const default_len: usize = @intCast(c.PyList_Size(default_objs));
    for (0..default_len) |i| {
        const default_obj = c.PyList_GetItem(default_objs, @intCast(i));
        std.debug.assert(default_obj != null);
        const value_obj = c.PyObject_GetAttrString(default_obj, "value");
        std.debug.assert(value_obj != null);

        const param_index = params.items.len - default_len + i;
        const param = &params.items[param_index];
        params.items[param_index].default = try parseConstant(value_obj, param.type, alloc);
    }

    // return type
    const returns = c.PyObject_GetAttrString(stmt, "returns");
    const return_type = try parseTypeAnnotation(returns, ir_builder, alloc);
    // walk annotation to get function kind
    const kind: FunctionKind = if (try hasDecorator(stmt, "gpu"))
        .gpu_kernel
    else
        .host;
    const is_inline = try hasDecorator(stmt, "inline");

    // append class name onto its methods
    const definition_name = if (class_id) |id| blk: {
        const class = ir_builder.getClass(id);
        const name = try std.fmt.allocPrint(alloc, "{s}__{s}", .{ class.name, func_name });
        break :blk name;
    } else func_name;
    defer if (class_id != null) alloc.free(definition_name);

    try ir_builder.program.functions.append(alloc, try Function.init(
        definition_name,
        ir_builder.nextFunctionId(),
        ir_builder.current_module_id,
        ir_builder.current_module_name,
        try params.toOwnedSlice(alloc),
        try type_params.toOwnedSlice(alloc),
        return_type,
        ir_builder.function_origin,
        kind,
        is_inline,
        alloc,
    ));
    if (class_id) |id| {
        const function = &ir_builder.program.functions.items[ir_builder.program.functions.items.len - 1];
        try ir_builder.getClass(id).methods.append(alloc, .{
            .name = try alloc.dupe(u8, func_name),
            .function_id = function.id,
            .function_label = try alloc.dupe(u8, function.label),
            .is_static = is_static,
        });
    }

    // save function state
    const saved_current_function = ir_builder.current_function;
    const saved_current_block = ir_builder.current_block;
    var saved_local_values = try ir_builder.cloneLocalValues(alloc);
    defer IrBuilder.deinitLocalValues(&saved_local_values, alloc);

    // set function state
    ir_builder.current_function = ir_builder.program.functions.items.len - 1;
    ir_builder.current_block = 0;
    ir_builder.clearLocalValues(alloc);

    // restore function state
    ir_builder.current_function = saved_current_function;
    ir_builder.current_block = saved_current_block;
    try ir_builder.restoreLocalValues(&saved_local_values, alloc);
}

pub fn parseConstant(
    value_obj: *PyObject,
    expected_type: ?TypeInfo,
    alloc: std.mem.Allocator,
) !ParsedConstant {
    const value_type = getPyType(value_obj);
    if (std.mem.eql(u8, value_type, "int")) {
        const value: ConstValue = .{ .i64 = c.PyLong_AsLong(value_obj) };
        return .{ .immediate = try value.coherce(expected_type) };
    } else if (std.mem.eql(u8, value_type, "float")) {
        const value: ConstValue = .{ .f64 = c.PyFloat_AsDouble(value_obj) };
        return .{ .immediate = try value.coherce(expected_type) };
    } else if (std.mem.eql(u8, value_type, "bool")) {
        const value: ConstValue = .{ .bool = c.PyObject_IsTrue(value_obj) == 1 };
        return .{ .immediate = try value.coherce(expected_type) };
    } else if (std.mem.eql(u8, value_type, "str")) {
        var raw_len: isize = 0;
        const raw = c.PyUnicode_AsUTF8AndSize(value_obj, &raw_len);
        std.debug.assert(raw != null);
        const bytes = raw[0..@intCast(raw_len)];

        if (expected_type) |t| {
            if (t == .char) {
                std.debug.assert(bytes.len == 1);
                return .{ .immediate = .{ .char = bytes[0] } };
            }
        }

        return try makeStringLiteral(bytes, alloc);
    }
    std.debug.print("cant handle {s}\n", .{value_type});
    return error.TypeNotImpl;
}

pub fn makeStringLiteral(bytes: []const u8, alloc: std.mem.Allocator) !ParsedConstant {
    var elements: ArrayList(ValueRef) = .empty;
    // var element_types: ArrayList(TypeInfo) = .empty;
    for (bytes) |char| {
        try elements.append(alloc, .{ .constant = .{
            .char = char,
        } });
        // try element_types.append(alloc, .char);
    }
    // null terminator
    try elements.append(alloc, .{ .constant = .{
        .char = 0,
    } });
    // try element_types.append(alloc, .char);

    const _type: TypeInfo = .{
        .list = .{
            // .elements = try element_types.toOwnedSlice(alloc),
            .element = try TypeInfo.toOwnedPointer(.char, alloc),
            // .size = elements.items.len,
        },
    };

    return .{ .composite = .{
        .elements = try elements.toOwnedSlice(alloc),
        .type = _type,
    } };
}

pub fn parseTypeAnnotation(
    annotation: *PyObject,
    irBuilder: *IrBuilder,
    alloc: std.mem.Allocator,
) !TypeInfo {
    const kind = getPyType(annotation);
    // Name(id='int', ctx=Load())
    if (std.mem.eql(u8, kind, "Name")) {
        const annotation_id_obj = c.PyObject_GetAttrString(annotation, "id");
        std.debug.assert(annotation_id_obj != null);
        const annotation_id = c.PyUnicode_AsUTF8(annotation_id_obj);
        std.debug.assert(annotation_id != null);

        const annotation_name = std.mem.span(annotation_id);
        if (std.mem.eql(u8, annotation_name, "int")) return .i64;
        if (std.mem.eql(u8, annotation_name, "i32")) return .i32;
        if (std.mem.eql(u8, annotation_name, "bool")) return .bool;
        if (std.mem.eql(u8, annotation_name, "float")) return .f64;
        if (std.mem.eql(u8, annotation_name, "f32")) return .f32;
        if (std.mem.eql(u8, annotation_name, "char")) return .char;
        if (std.mem.eql(u8, annotation_name, "str")) {
            return .{ .list = .{ .element = try TypeInfo.toOwnedPointer(.char, alloc) } };
        }
        if (irBuilder.getActiveParmType(annotation_name)) |param_type| {
            return .{ .type_variable = param_type.id };
        }
        if (irBuilder.findClass(annotation_name)) |class| {
            if (class.type_params.len != 0) return error.InvalidTypeArgCount;
            return .{ .instance = .{
                .class_id = class.id,
                .args = try alloc.alloc(TypeInfo, 0),
            } };
        }
        if (irBuilder.currentFunction().findTypeParam(annotation_name)) |type_param| {
            return .{
                .type_variable = type_param.id,
            };
        }
        std.debug.print("cant handle {s}\n", .{annotation_id});
        return error.TypeNotImplemented;
    } else if (std.mem.eql(u8, kind, "Subscript")) {
        const slice_obj = c.PyObject_GetAttrString(annotation, "slice");
        std.debug.assert(slice_obj != null);

        switch (try getSubscriberType(annotation, irBuilder)) {
            // Subscript(value=Name(id='list', ctx=Load()), slice=Name(id='int', ctx=Load()), ctx=Load())
            .list => {
                // recursively get type
                const elem_type = try parseTypeAnnotation(slice_obj, irBuilder, alloc);
                return .{ .list = .{
                    .element = try elem_type.toOwnedPointer(alloc),
                } };
            },
            // Subscript(value=Name(id='tuple', ctx=Load()), slice=Tuple(elts=[Name(id='int', ctx=Load()), Name(id='int', ctx=Load())], ctx=Load()), ctx=Load())
            .tuple => {
                const elts = c.PyObject_GetAttrString(slice_obj, "elts");
                std.debug.assert(elts != null);
                const len: usize = @intCast(c.PyList_Size(elts));
                const elem_types = try alloc.alloc(TypeInfo, len);
                for (0..len) |i| {
                    const elt = c.PyList_GetItem(elts, @intCast(i));
                    std.debug.assert(elt != null);
                    elem_types[i] = try parseTypeAnnotation(elt, irBuilder, alloc);
                }
                return .{ .tuple = .{
                    .elements = elem_types,
                } };
            },
            // Subscript(value=Name(id='Callable', ctx=Load()), slice=Tuple(elts=[List(elts=[Name(id='bool', ctx=Load())], ctx=Load()), Name(id='int', ctx=Load())], ctx=Load()), ctx=Load())
            .callable => {
                const elts = c.PyObject_GetAttrString(slice_obj, "elts");
                std.debug.assert(elts != null);
                const len: usize = @intCast(c.PyList_Size(elts));
                std.debug.assert(len == 2);
                const params_obj = c.PyList_GetItem(elts, 0);
                std.debug.assert(params_obj != null);
                const return_obj = c.PyList_GetItem(elts, 1);
                std.debug.assert(return_obj != null);

                const params_elts = c.PyObject_GetAttrString(params_obj, "elts");
                std.debug.assert(params_elts != null);
                const input_len: usize = @intCast(c.PyList_Size(params_elts));
                const elem_types = try alloc.alloc(TypeInfo, input_len);
                for (0..input_len) |i| {
                    const elt = c.PyList_GetItem(params_elts, @intCast(i));
                    std.debug.assert(elt != null);
                    elem_types[i] = try parseTypeAnnotation(elt, irBuilder, alloc);
                }

                return .{ .callable = .{
                    .params = elem_types,
                    .returns = try (try parseTypeAnnotation(return_obj, irBuilder, alloc)).toOwnedPointer(alloc),
                } };
            },
            .instance => |class_id| {
                const class = irBuilder.getClass(class_id);
                const arity = class.type_params.len;

                if (arity == 0) return error.InvalidTypeArgCount;

                const args = try alloc.alloc(TypeInfo, arity);

                // arity = 1 is a special case
                // more args get pushed into elts
                if (arity == 1) {
                    args[0] = try parseTypeAnnotation(slice_obj, irBuilder, alloc);
                } else {
                    return error.NotImpl;
                }

                return .{ .instance = .{
                    .class_id = class_id,
                    .args = args,
                } };
            },
        }
    } else if (std.mem.eql(u8, kind, "Constant")) {
        const value_obj = c.PyObject_GetAttrString(annotation, "value");
        if (value_obj == c.Py_None()) {
            return .void;
        }
        if (!std.mem.eql(u8, getPyType(value_obj), "str")) {
            return error.ExpectedString;
        }
        // classes support string type lookup
        const raw_class_name = c.PyUnicode_AsUTF8(value_obj);
        const class = irBuilder.findClass(std.mem.span(raw_class_name)) orelse {
            return error.CantFindClass;
        };
        return .{ .instance = .{
            .class_id = class.id,
            .args = try alloc.alloc(TypeInfo, 0),
        } };
    }
    std.debug.print("kind not supported {s}\n", .{kind});
    return error.NotImpl;
}

pub fn getSubscriberType(annotation: *PyObject, irBuilder: *IrBuilder) !SubscriberTypes {
    const value_obj = c.PyObject_GetAttrString(annotation, "value");
    std.debug.assert(value_obj != null);
    const id_obj = c.PyObject_GetAttrString(value_obj, "id");
    std.debug.assert(id_obj != null);
    const name = std.mem.span(c.PyUnicode_AsUTF8(id_obj));
    if (std.mem.eql(u8, name, "list")) return .list;
    if (std.mem.eql(u8, name, "tuple")) return .tuple;
    if (std.mem.eql(u8, name, "Callable")) return .callable;
    if (irBuilder.findClass(name)) |class| {
        return .{ .instance = class.id };
    }

    std.debug.print("unknown annotation base {s}\n", .{name});
    return error.InvalidSubscriber;
}

// ClassDef(name='MiniTorch', type_params=[ TypeVar(name='T')], body=[...])
pub fn parseTypeParams(stmt: *PyObject, start_id: u32, alloc: std.mem.Allocator) ![]TypeParam {
    const type_params = PyObject.GetAttrString(stmt, "type_params");
    std.debug.assert(type_params != null);

    const type_params_size: usize = @intCast(c.PyList_Size(type_params));
    const result = try alloc.alloc(TypeParam, type_params_size);
    for (0..type_params_size) |i| {
        const type_param = c.PyList_GetItem(type_params, @intCast(i));
        std.debug.assert(type_param != null);
        const name_obj = PyObject.GetAttrString(type_param, "name");
        std.debug.assert(name_obj != null);
        const name = PyObject.PyUnicode_AsUTF8(name_obj);
        std.debug.assert(name != null);

        result[i] = .{
            .name = try alloc.dupe(u8, std.mem.span(name)),
            .id = start_id + @as(@FieldType(TypeParam, "id"), @intCast(i)),
        };
    }
    return result;
}

pub fn hasDecorator(stmt: *PyObject, target_decorator: []const u8) !bool {
    const decorators = PyObject.GetAttrString(stmt, "decorator_list");
    std.debug.assert(decorators != null);
    for (0..@intCast(c.PyList_Size(decorators))) |i| {
        const decorator = c.PyList_GetItem(decorators, @intCast(i));
        std.debug.assert(decorator != null);

        if (!std.mem.eql(u8, getPyType(decorator), "Name")) {
            return error.InvalidDecorator;
        }
        const id_obj = PyObject.GetAttrString(decorator, "id");
        std.debug.assert(id_obj != null);
        const raw_name = c.PyUnicode_AsUTF8(id_obj);
        std.debug.assert(raw_name != null);
        if (std.mem.eql(u8, std.mem.span(raw_name), target_decorator)) {
            return true;
        }
    }
    return false;
}
