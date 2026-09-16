const std = @import("std");
const ArrayList = std.ArrayList;
const HashMap = std.HashMap;
const ModuleId = @import("common").module.ModuleId;
const BasicBlock = @import("common").ir.BasicBlock;
const ClassId = @import("common").ir.ClassId;
const Operand = @import("common").alloc.Operand;
const TypedOperand = @import("common").alloc.TypedOperand;
const Param = @import("common").ir.Param;
const TypeParam = @import("common").ir.TypeParam;
const ValueRef = @import("common").ir.ValueRef;
const Function = @import("common").ir.Function;
const Program = @import("common").program.Program;
const Instruction = @import("common").mir.Instruction;
const TypeBindings = @import("common").types.TypeBindings;
const TypeInfo = @import("common").types.TypeInfo;

pub fn rewrite(program: *Program, alloc: std.mem.Allocator) !void {
    var pending: ArrayList(Function) = .empty;
    defer pending.deinit(alloc);

    try rewriteFunction(program, &program.main, &pending, alloc);
    try program.functions.appendSlice(alloc, pending.items);
    pending.clearRetainingCapacity();
    var function_index: usize = 0;
    while (function_index < program.functions.items.len) : (function_index += 1) {
        const function = &program.functions.items[function_index];
        // skip generics looking for more generics
        // calls into generics should handle this scenario
        if (function.type_params.len > 0) continue;
        try rewriteFunction(program, function, &pending, alloc);
        try program.functions.appendSlice(alloc, pending.items);
        pending.clearRetainingCapacity();
    }
}

/// rewrite function distructively
fn rewriteFunction(
    program: *Program,
    function: *Function,
    pending: *ArrayList(Function),
    alloc: std.mem.Allocator,
) !void {
    for (function.blocks.items) |*block| {
        var new_instructions: ArrayList(Instruction) = .empty;
        errdefer new_instructions.deinit(alloc);
        for (block.instructions.items) |*instruction| {
            switch (instruction.*) {
                .function_call => |*fc| {
                    switch (fc.callee) {
                        .direct => |*name| {
                            try specializeInvocation(
                                name,
                                program,
                                pending,
                                if (fc.dst) |*dst| dst else null,
                                fc.args,
                                function,
                                alloc,
                            );
                        },
                        else => {},
                    }
                    try new_instructions.append(alloc, instruction.*);
                },
                .gpu_launch => |*gl| {
                    try specializeInvocation(&gl.kernel, program, pending, null, gl.args, function, alloc);
                    try new_instructions.append(alloc, instruction.*);
                },
                else => try new_instructions.append(alloc, instruction.*),
            }
        }
        block.instructions.deinit(alloc);
        block.instructions = new_instructions;
    }
}

fn specializeInvocation(callee_name: *[]const u8, program: *Program, pending: *ArrayList(Function), maybe_dst: ?*TypedOperand, args: []TypedOperand, function: *Function, alloc: std.mem.Allocator) !void {
    var maybe_specialized = try specializeCall(callee_name.*, program, pending, args, alloc);
    if (maybe_specialized) |*specialized| {
        defer specialized.deinit(alloc);
        if (maybe_dst) |dst| {
            dst.replaceType(specialized.takeReturnType(), alloc);

            try function.setValueType(dst.operand, dst.type, alloc);
        }

        alloc.free(callee_name.*);
        callee_name.* = specialized.takeLabel();
    }
}

const SpecializeCall = struct {
    label: ?[]const u8,
    return_type: ?TypeInfo,

    pub fn deinit(self: *@This(), alloc: std.mem.Allocator) void {
        if (self.label) |label| alloc.free(label);
        if (self.return_type) |return_type| {
            return_type.deinit(alloc);
        }

        self.* = undefined;
    }

    pub fn takeLabel(self: *@This()) []const u8 {
        const label = self.label orelse unreachable;
        self.label = null;
        return label;
    }

    pub fn takeReturnType(self: *@This()) TypeInfo {
        const return_type = self.return_type orelse unreachable;
        self.return_type = null;
        return return_type;
    }
};

fn specializeCall(
    callee_name: []const u8,
    program: *Program,
    pending: *ArrayList(Function),
    args: []const TypedOperand,
    alloc: std.mem.Allocator,
) !?SpecializeCall {
    const callee = program.findFunction(callee_name) orelse {
        return null;
    };
    // check for generics
    var bindings: TypeBindings = .init(alloc);
    defer bindings.deinit(alloc);
    // early return if we have no generics
    if (callee.type_params.len == 0) {
        return null;
    }
    if (callee.params.len != args.len) {
        return null;
    }

    // populate
    for (callee.params, args) |param, arg| {
        try TypeInfo.unify(param.type, arg.type, &bindings, alloc);
    }

    // skip specialization for generic templates
    for (callee.type_params) |type_param| {
        const bound_type = bindings.get(type_param.id) orelse {
            return null;
        };
        if (bound_type == .type_variable) {
            return null;
        }
    }

    const specialized_func_name = try specializeName(
        callee.name,
        callee.type_params,
        &bindings,
        alloc,
    );
    defer alloc.free(specialized_func_name);

    var return_type = try callee.return_type.substitute(&bindings, alloc);
    errdefer return_type.deinit(alloc);
    // return type can be a generic class also
    _ = try specializeClassInstance(&return_type, program, alloc);

    const specialized_function: *const Function = program.findFunctionInModule(specialized_func_name, callee.module_id) orelse findFunctionIn(pending.items, specialized_func_name, callee.module_id) orelse blk: {
        var specialized = try callee.specialize(
            specialized_func_name,
            program.functions.items.len + pending.items.len + 1,
            &bindings,
            alloc,
        );
        errdefer specialized.deinit(alloc);
        try pending.append(alloc, specialized);
        break :blk &pending.items[pending.items.len - 1];
    };

    return .{
        .label = try alloc.dupe(u8, specialized_function.label),
        .return_type = return_type,
    };
}

fn specializeClassInstance(
    type_info: *TypeInfo,
    program: *Program,
    alloc: std.mem.Allocator,
) !bool {
    const instance = switch (type_info.*) {
        .instance => |instance| instance,
        else => return false,
    };
    if (instance.args.len == 0) return false;

    const specialized_id = try specializeClass(program, instance.class_id, instance.args, alloc);
    const replacement: TypeInfo = .{ .instance = .{
        .class_id = specialized_id,
        .args = try alloc.alloc(TypeInfo, 0),
    } };
    type_info.replaceType(replacement, alloc);

    return true;
}

fn specializeClass(
    program: *Program,
    template_id: ClassId,
    specialized_args: []const TypeInfo,
    alloc: std.mem.Allocator,
) !ClassId {
    const template = &program.classes.items[template_id];
    // check for generics
    var bindings: TypeBindings = .init(alloc);
    defer bindings.deinit(alloc);

    // concrete class doesn't need specialization
    if (template.type_params.len == 0) {
        return template_id;
    }

    if (template.type_params.len != specialized_args.len) {
        return error.InvalidTypeArgCount;
    }
    // Map[T, U] => T.id -> i32, U.id -> f64
    for (template.type_params, specialized_args) |param, arg| {
        try bindings.put(param.id, try arg.clone(alloc));
    }

    const specialized_name = try specializeName(template.name, template.type_params, &bindings, alloc);
    defer alloc.free(specialized_name);
    // check if specialization already exists
    for (program.classes.items) |class| {
        if (class.template_id != null and class.template_id.? == template_id and std.mem.eql(u8, class.name, specialized_name)) {
            return class.id;
        }
    }

    const specialized_id: ClassId = @intCast(program.classes.items.len);
    // std.debug.print("specialized {s} as class_{d}\n", .{ specialized_name, specialized_id });
    const specialized = try template.specialize(specialized_name, specialized_id, &bindings, alloc);
    try program.classes.append(alloc, specialized);
    return specialized_id;
}

fn specializeName(
    base_name: []const u8,
    type_params: []TypeParam,
    bindings: *TypeBindings,
    alloc: std.mem.Allocator,
) ![]const u8 {
    var out: ArrayList(u8) = .empty;
    errdefer out.deinit(alloc);

    try out.appendSlice(alloc, base_name);
    // Box[M, N] => Box__{typeof(M)}_{typeof(N)}
    try out.appendSlice(alloc, "__");

    for (type_params, 0..) |type_param, i| {
        // append _ between composite generics for better readability
        if (i != 0) try out.appendSlice(alloc, "_");

        const bound_type = bindings.get(type_param.id) orelse return error.ExpectedBinding;
        const type_name = try bound_type.toString(alloc);
        defer alloc.free(type_name);
        try out.appendSlice(alloc, type_name);
    }

    return out.toOwnedSlice(alloc);
}

fn findFunctionIn(functions: []const Function, function_name: []const u8, module_id: ModuleId) ?*const Function {
    for (functions) |*function| {
        if (function.module_id == module_id and std.mem.eql(u8, function.name, function_name)) {
            return function;
        }
    }
    return null;
}

pub fn dropTemplates(program: *Program, alloc: std.mem.Allocator) void {
    var write_index: usize = 0;
    for (program.functions.items, 0..) |*function, read_index| {
        if (function.type_params.len > 0) {
            function.deinit(alloc);
            continue;
        }

        if (read_index != write_index) {
            program.functions.items[write_index] = function.*;
        }
        write_index += 1;
    }
    program.functions.items.len = write_index;
}
