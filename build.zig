const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("ztime.elf", "src/main.zig");
    exe.setTarget(try std.zig.CrossTarget.parse(.{
        .arch_os_abi = "thumb-freestanding-eabi",
        .cpu_features = "cortex_m4",
    }));
    exe.setBuildMode(.ReleaseSmall);
    exe.strip = true;
    exe.setLinkerScriptPath("src/link.ld");
    exe.install();

    const hex = b.step("hex", "Generate hex file");
    hex.dependOn(&exe.step);
    hex.dependOn(&b.addSystemCommand(&[_][]const u8{
        "llvm-objcopy",
        "zig-cache/bin/ztime.elf",
        "ztime.bin",
    }).step);
    hex.dependOn(&b.addSystemCommand(&[_][]const u8{
        "llvm-objcopy",
        "ztime.bin",
        "ztime.ihex",
    }).step);

    var main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
