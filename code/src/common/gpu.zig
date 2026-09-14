const c = @cImport({
    @cInclude("gpu_layout.h");
});

pub const GpuListField = c.GpuListField;
pub const GpuInstanceLayout = c.GpuInstanceLayout;
