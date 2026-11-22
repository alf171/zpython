// goal of this file is to go from interference graph to a colored inteference graph
const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const Writer = std.Io.Writer;

const graph = @import("igraph.zig");
const RegisterFile = @import("common").register.RegisterFile;
const Operand = @import("common").alloc.Operand;
const RegisterClass = @import("common").register.RegisterClass;
const RegisterType = @import("common").register.RegisterType;

pub fn Set(comptime K: type) type {
    return std.AutoHashMap(K, void);
}

pub const Assignment = struct {
    register: u8,
    reg_class: RegisterClass,
};

pub const ColoredGraph = struct {
    nodes: std.AutoHashMap(Operand, Assignment),

    // compose a node with a register since we need it for coloring
    pub fn init(allocator: Allocator) @This() {
        return .{
            .nodes = .init(allocator),
        };
    }

    pub fn deinit(self: *@This()) void {
        self.nodes.deinit();
    }

    pub fn absorb(self: *@This(), other: *@This()) !void {
        // ensure we have enough space to avoid partial failures
        try self.nodes.ensureUnusedCapacity(other.nodes.count());

        var other_it = other.nodes.iterator();
        while (other_it.next()) |other_entry| {
            try self.nodes.put(
                other_entry.key_ptr.*,
                other_entry.value_ptr.*,
            );
        }
        other.nodes.clearRetainingCapacity();
    }

    pub fn print(self: *@This(), allocator: Allocator, stdout: *Writer) !void {
        try stdout.print("colored graph: [register] temp -> interfer temp/s\n", .{});
        var it = self.nodes.iterator();
        while (it.next()) |node_ptr| {
            const key_str = try node_ptr.key_ptr.*.toString(allocator);
            defer allocator.free(key_str);
            const value = node_ptr.value_ptr.*;

            var buf: ArrayList(u8) = .init(allocator);
            defer buf.deinit();

            var inner_it = value.node.neighbors.iterator();
            const reg = value.register;
            var i: usize = 0;
            while (inner_it.next()) |value_ptr| : (i += 1) {
                const str = try value_ptr.key_ptr.toString(allocator);
                defer allocator.free(str);
                try buf.appendSlice(str);
                if (i + 1 != value.node.neighbors.count()) {
                    try buf.appendSlice(", ");
                }
            }

            try stdout.print("[{?d}] {s} -> ({s})\n", .{ reg, key_str, buf.items });
            try stdout.flush();
        }
    }
};

const ColorGraphAttempt = union(enum) {
    graph: ColoredGraph,
    spill_before_color: Operand,
    spill_after_color: Operand,
};

/// color a graph and generate a new graph via spilling if needed
/// at what layer of abstraction should we do all of this is still being decided
pub fn colorGraph(input: *graph.IGraph, register_file: RegisterFile, allocator: Allocator) !ColorGraphAttempt {
    // things to keep track of
    var simplify: Set(Operand) = .init(allocator);
    defer simplify.deinit();
    var spill: Set(Operand) = .init(allocator);
    defer spill.deinit();

    // phase 1, build simplify and spill
    {
        var it = input.nodes.iterator();
        while (it.next()) |ptr| {
            const node = ptr.value_ptr;

            // skip already seen nodes, pre allocated registers, and spilled registers
            if (node.selected or node.val == .reg or node.val == .mem) {
                continue;
            }

            if (node.cur_degree < register_file.legalCount(node.forbidden_colors)) {
                try simplify.put(node.val, {});
            } else {
                try spill.put(node.val, {});
            }
        }
    }

    var new_graph: ColoredGraph = .init(allocator);

    var select: ArrayList(Operand) = .empty;
    defer select.deinit(allocator);

    // phase 2: build select
    while (simplify.count() > 0 or spill.count() > 0) {
        if (simplify.count() > 0) {
            const id = try takeAny(&simplify);
            const node = input.nodes.getPtr(id) orelse {
                return error.CantFindNode;
            };
            if (!node.selected) {
                try removeNode(input, node.*, &select, &simplify, &spill, register_file, allocator);
            }
        } else {
            // TODO: write test case for not throwing spilling in here
            const id = try takeNodeWithCheapestSpill(input.nodes, &spill);
            const node = input.nodes.getPtr(id) orelse return error.CantFindNode;
            try removeNode(input, node.*, &select, &simplify, &spill, register_file, allocator);
        }
    }

    // phase 3: select + color
    while (select.items.len > 0) {
        const id = select.pop().?;
        const node = input.nodes.getPtr(id) orelse return error.CantFindNode;

        const reg = try scanForRegister(node, &new_graph, register_file.count) orelse {
            const str = try id.toString(allocator);
            defer allocator.free(str);
            // std.debug.print("couldn't find register for {s}\n", .{str});
            new_graph.deinit();
            return .{ .spill_after_color = id };
        };
        try new_graph.nodes.put(id, .{
            .register = reg,
            .reg_class = node.reg_class,
        });
    }

    // phase 4: swap Operand aliases
    {
        var it = input.aliases.iterator();
        while (it.next()) |key| {
            const old = key.key_ptr.*;
            const new = input.resolveAlias(key.value_ptr.*);

            const rep_colors = new_graph.nodes.get(new) orelse return error.CantFindAlias;

            try new_graph.nodes.put(old, .{
                .register = rep_colors.register,
                .reg_class = rep_colors.reg_class,
            });
        }
    }

    return .{ .graph = new_graph };
}

/// build our select stack. move things between simplify and spill as needed
fn removeNode(
    input: *const graph.IGraph,
    node: graph.Node,
    select: *ArrayList(Operand),
    simplify: *Set(Operand),
    spill: *Set(Operand),
    register_file: RegisterFile,
    alloc: std.mem.Allocator,
) !void {
    std.debug.assert(node.val != .reg);
    std.debug.assert(!node.selected);
    try select.append(alloc, node.val);
    const item = input.nodes.getPtr(node.val).?;
    item.selected = true;

    // dec nbors
    var n_bor = node.neighbors.keyIterator();
    while (n_bor.next()) |n_ptr| {
        const n = input.nodes.getPtr(n_ptr.*) orelse {
            std.log.debug("cant find nbor node", .{});
            return error.CantFindNode;
        };

        if (n.selected or n.val == .reg or n.val == .mem) {
            continue;
        }

        // if we go from k -> k - 1, move from spill to select
        if (n.cur_degree == register_file.legalCount(n.forbidden_colors)) {
            std.debug.assert(spill.contains(n_ptr.*));
            std.debug.assert(!simplify.contains(n_ptr.*));
            _ = spill.remove(n_ptr.*);
            _ = try simplify.put(n_ptr.*, {});
        }
        n.cur_degree -= 1;
    }
}

// spill cost / degree
fn takeNodeWithCheapestSpill(
    input_graph: std.AutoHashMap(Operand, graph.Node),
    canadidites: *std.AutoHashMap(Operand, void),
) !Operand {
    var it = canadidites.keyIterator();
    var best_id: ?Operand = null;
    var best_cost: u32 = 0;
    var best_degree: u16 = 1;

    while (it.next()) |candidate| {
        const node = input_graph.get(candidate.*) orelse continue;

        const degree = @max(node.static_degree, 1);
        // base case
        if (best_id == null) {
            best_id = candidate.*;
            best_degree = degree;
            best_cost = node.spill_cost;
            continue;
        }
        // cross product to change to multiplies
        const candidate_score: u64 = @as(u64, node.spill_cost) * @as(u64, best_degree);
        const best_score: u64 = @as(u64, best_cost) * @as(u64, degree);
        if (candidate_score < best_score) {
            best_id = candidate.*;
            best_degree = degree;
            best_cost = node.spill_cost;
        }
    }
    const id = best_id orelse return error.IllegalGraph;
    _ = canadidites.remove(id);
    return id;
}

/// remove a node from map and return it to the caller
/// this fun is deterministic
fn takeAny(s: *std.AutoHashMap(Operand, void)) !Operand {
    var best: ?Operand = null;
    var it = s.keyIterator();
    while (it.next()) |candidate| {
        if (best == null or candidate.*.lessThan(best.?)) {
            best = candidate.*;
        }
    }
    const selected = best orelse return error.IllegalGraph;
    _ = s.remove(selected);
    return selected;
}

// take a node. determininstically find lowest reg available
// skip registers based on callee_save_mask
fn scanForRegister(node: *const graph.Node, coloring: *ColoredGraph, k: u16) !?u8 {
    scan: for (0..k) |scan_reg| {
        // bit mask skip logic
        const end = scan_reg + node.reg_class.count;
        if (end > k) continue;

        for (scan_reg..end) |reg| {
            const mask = @as(u32, 1) << @intCast(reg);
            if (node.forbidden_colors & mask != 0) {
                continue :scan;
            }
        }

        // align width 2 sclar registers
        if (node.reg_class.type == .sgpr and node.reg_class.count == 2 and scan_reg % 2 != 0) {
            continue;
        }

        // selection logic
        var it = node.neighbors.keyIterator();
        while (it.next()) |key| {
            const nbor = coloring.nodes.get(key.*) orelse continue;
            if (overlaps(@intCast(scan_reg), node.reg_class.count, nbor.register, nbor.reg_class.count)) {
                continue :scan;
            }
        }
        return @intCast(scan_reg);
    }
    return null;
}

// [a] + aw, [b] + bw
fn overlaps(a: u8, aw: u8, b: u8, bw: u8) bool {
    return a < b + bw and b < a + aw;
}
