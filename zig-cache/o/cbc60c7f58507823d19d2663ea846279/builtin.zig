usingnamespace @import("std").builtin;
/// Deprecated
pub const arch = Target.current.cpu.arch;
/// Deprecated
pub const endian = Target.current.cpu.arch.endian();
pub const output_mode = OutputMode.Exe;
pub const link_mode = LinkMode.Static;
pub const is_test = false;
pub const single_threaded = false;
pub const abi = Abi.eabi;
pub const cpu: Cpu = Cpu{
    .arch = .thumb,
    .model = &Target.arm.cpu.cortex_m4,
    .features = Target.arm.featureSet(&[_]Target.arm.Feature{
        .@"db",
        .@"dsp",
        .@"fp16",
        .@"fpregs",
        .@"has_v4t",
        .@"has_v5t",
        .@"has_v5te",
        .@"has_v6",
        .@"has_v6k",
        .@"has_v6m",
        .@"has_v6t2",
        .@"has_v7",
        .@"has_v7clrex",
        .@"has_v8m",
        .@"hwdiv",
        .@"loop_align",
        .@"mclass",
        .@"no_branch_predictor",
        .@"noarm",
        .@"perfmon",
        .@"slowfpvfmx",
        .@"slowfpvmlx",
        .@"thumb2",
        .@"thumb_mode",
        .@"use_misched",
        .@"v7em",
        .@"vfp2sp",
        .@"vfp3d16sp",
        .@"vfp4d16sp",
    }),
};
pub const os = Os{
    .tag = .freestanding,
    .version_range = .{ .none = {} }
};
pub const object_format = ObjectFormat.elf;
pub const mode = Mode.ReleaseSmall;
pub const link_libc = false;
pub const link_libcpp = false;
pub const have_error_return_tracing = false;
pub const valgrind_support = false;
pub const position_independent_code = false;
pub const strip_debug_info = true;
pub const code_model = CodeModel.default;
