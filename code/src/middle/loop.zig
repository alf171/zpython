const std = @import("std");
const parser = @import("parse.zig");
const igraph = @import("igraph.zig");
const color = @import("color.zig");
const spill = @import("spill.zig");
const live = @import("live.zig");
const coalesce = @import("coalesce.zig");
const reg_alloc = @import("reg_alloc.zig");
const reg_class = @import("reg_class.zig");

const Allocator = std.mem.Allocator;
const AllocProgram = @import("common").alloc.AllocProgram;
const IrProgram = @import("common").program.Program;
const Function = @import("common").function.Function;
const FunctionType = @import("common").function.FunctionType;
const RegisterClasses = @import("common").register.RegisterClasses;
const RegisterFile = @import("common").register.RegisterFile;
const TimerMetrics = @import("common").timer.TimerMetrics;
const Writer = std.Io.Writer;

pub const RunResult = struct {
    spill_rounds: std.EnumArray(FunctionType, usize),
    graph: color.ColoredGraph,
};

/// feedback loop of program (lines of IR) -> inteference graph -> colored graph
/// if we spill, create a new IR lines and repeat
pub fn run(
    function: *Function,
    alloc_program: *AllocProgram,
    register_file: RegisterFile,
    should_coalesce: bool,
    timer: *TimerMetrics,
    io: std.Io,
    alloc: Allocator,
) !RunResult {
    var spill_rounds: std.EnumArray(FunctionType, usize) = .initFill(0);
    while (true) {
        timer.begin(.middle_igraph, io);
        var graph = try igraph.createIgraph(
            alloc_program.lines,
            register_file,
            alloc,
        );
        defer graph.deinit();
        timer.finish(.middle_igraph, io);

        if (should_coalesce) {
            timer.begin(.middle_coalesce, io);
            try coalesce.run(&graph, register_file);
            timer.finish(.middle_coalesce, io);
        }
        timer.begin(.middle_color, io);
        const attempt = try color.colorGraph(&graph, register_file, alloc);
        timer.finish(.middle_color, io);
        switch (attempt) {
            .graph => |colored| {
                return .{
                    .graph = colored,
                    .spill_rounds = spill_rounds,
                };
            },
            .spill_register => |spilled| {
                spill_rounds.getPtr(function.origin).* += 1;
                // spill in ir
                timer.begin(.middle_spill_reg, io);
                try spill.spillRegInFunction(function, spilled, alloc);
                timer.finish(.middle_spill_reg, io);
                // select register types
                timer.begin(.middle_reg_class, io);
                var reg_classes: RegisterClasses = .init(alloc);
                defer reg_classes.deinit();
                try reg_class.classifyFunction(function.*, &reg_classes);
                timer.finish(.middle_reg_class, io);
                // rebuild alloc according to our spill
                timer.begin(.middle_reg_alloc_build, io);
                var rebuild = try reg_alloc.buildFunction(function.*, &reg_classes, alloc);
                errdefer rebuild.deinit(alloc);
                timer.finish(.middle_reg_alloc_build, io);
                timer.begin(.middle_liveness, io);
                try live.calculateLiveOut(&rebuild, alloc);
                timer.finish(.middle_liveness, io);
                // update state
                alloc_program.deinit(alloc);
                alloc_program.* = rebuild;
            },
        }
    }
}

test "test" {
    std.testing.refAllDecls(@This());
}
