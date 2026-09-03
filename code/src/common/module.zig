pub const ModuleId = u16;

pub const ImportFunction = struct {
    id: ModuleId,
    function_name: []const u8,
    alias: ?[]const u8,
};
