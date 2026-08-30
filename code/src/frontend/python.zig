const std = @import("std");

pub const c = @cImport({
    @cInclude("Python.h");
});
pub const PyObject = c.PyObject;

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
