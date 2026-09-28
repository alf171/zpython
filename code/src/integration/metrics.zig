const std = @import("std");
const FunctionType = @import("common").function.FunctionType;
const Target = @import("backend").Target;

const underline_code = "\x1b[4m";
const reset_code = "\x1b[0m";

pub const Metrics = struct {
    line_count: usize,
    mov_count: usize,
    memory_load_count: usize,
    memory_store_count: usize,
    conditional_jumps: usize,
    unconditional_jumps: usize,
    comparisons: usize,
    returns: usize,
    calls: usize,
    spill_rounds: usize,
    origin: FunctionType,

    pub fn init(origin: FunctionType, spill_rounds: usize) @This() {
        return .{
            .line_count = 0,
            .mov_count = 0,
            .memory_load_count = 0,
            .memory_store_count = 0,
            .conditional_jumps = 0,
            .unconditional_jumps = 0,
            .comparisons = 0,
            .returns = 0,
            .calls = 0,
            .spill_rounds = spill_rounds,
            .origin = origin,
        };
    }

    pub fn print(self: @This(), use_escape_codes: bool) void {
        std.debug.print("\n", .{});
        if (use_escape_codes) std.debug.print("{s}", .{underline_code});
        std.debug.print("performance report:", .{});
        if (use_escape_codes) std.debug.print("{s}", .{reset_code});
        std.debug.print(" (ORIGIN={s})\n", .{@tagName(self.origin)});
        std.debug.print("number of asm lines: {d}\n", .{self.line_count});
        std.debug.print("mov count: {d}\n", .{self.mov_count});
        std.debug.print("memory load count: {d}\n", .{self.memory_load_count});
        std.debug.print("memory store count: {d}\n", .{self.memory_store_count});
        std.debug.print("conditional jumps: {d}\n", .{self.conditional_jumps});
        std.debug.print("unconditional jumps: {d}\n", .{self.unconditional_jumps});
        std.debug.print("comparisons: {d}\n", .{self.comparisons});
        std.debug.print("returns: {d}\n", .{self.returns});
        std.debug.print("call count: {d}\n", .{self.calls});
        std.debug.print("spill rounds: {d}\n", .{self.spill_rounds});
    }
};

pub const MetricsReport = struct {
    user: Metrics,
    runtime: Metrics,
};

pub fn get(
    asm_text: []const u8,
    spill_counts: std.EnumArray(FunctionType, usize),
    target: Target,
) MetricsReport {
    var current_origin: FunctionType = .user;
    var runtime_metrics = Metrics.init(.runtime, spill_counts.get(.runtime));
    var user_metrics = Metrics.init(.user, spill_counts.get(.user));
    var lines = std.mem.splitScalar(u8, asm_text, '\n');
    while (lines.next()) |line| {
        const trim = std.mem.trim(u8, line, "\t");

        if (std.mem.endsWith(u8, trim, "origin: user")) {
            current_origin = .user;
            continue;
        }
        if (std.mem.endsWith(u8, trim, "origin: runtime")) {
            current_origin = .runtime;
            continue;
        }

        const current = switch (current_origin) {
            .runtime => &runtime_metrics,
            .user => &user_metrics,
        };

        if (trim.len == 0) continue;

        if (trim[0] == '.' or trim[0] == '_' or std.mem.endsWith(u8, trim, ":")) continue;

        current.line_count += 1;
        switch (target.host) {
            .ARM => {
                if (std.mem.startsWith(u8, trim, "mov") or std.mem.startsWith(u8, trim, "fmov")) current.mov_count += 1;
                if (std.mem.startsWith(u8, trim, "ldr") or std.mem.startsWith(u8, trim, "ldp")) current.memory_load_count += 1;
                if (std.mem.startsWith(u8, trim, "str") or std.mem.startsWith(u8, trim, "stp")) current.memory_store_count += 1;
                if (std.mem.startsWith(u8, trim, "b.")) current.conditional_jumps += 1;
                if (std.mem.startsWith(u8, trim, "b ")) current.unconditional_jumps += 1;
                if (std.mem.startsWith(u8, trim, "cmp") or std.mem.startsWith(u8, trim, "fcmp")) current.comparisons += 1;
                if (std.mem.startsWith(u8, trim, "ret")) current.returns += 1;
                if (std.mem.startsWith(u8, trim, "bl")) current.calls += 1;
            },
            // src, dst
            .X86 => {
                if (std.mem.startsWith(u8, trim, "push")) current.memory_store_count += 1;
                if (std.mem.startsWith(u8, trim, "pop")) current.memory_load_count += 1;
                if (std.mem.startsWith(u8, trim, "mov")) {
                    current.mov_count += 1;
                    if (std.mem.indexOfScalar(u8, trim, '(') != null) {
                        // movslq 0(%r12), %rdi
                        if (std.mem.indexOf(u8, trim, "),") != null) {
                            current.memory_load_count += 1;
                        }
                        // movq %rdi, 0(%r12)
                        else {
                            current.memory_store_count += 1;
                        }
                    }
                }
                if (std.mem.startsWith(u8, trim, "j") and !std.mem.startsWith(u8, trim, "jmp")) current.conditional_jumps += 1;
                if (std.mem.startsWith(u8, trim, "jmp")) current.unconditional_jumps += 1;
                if (std.mem.startsWith(u8, trim, "cmp") or std.mem.startsWith(u8, trim, "ucomis")) current.comparisons += 1;
                if (std.mem.startsWith(u8, trim, "ret")) current.returns += 1;
                if (std.mem.startsWith(u8, trim, "call")) current.calls += 1;
            },
            else => unreachable,
        }
    }

    return .{
        .runtime = runtime_metrics,
        .user = user_metrics,
    };
}
