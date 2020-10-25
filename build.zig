const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("ztime.elf", "src/main.zig");
    const gpio_layout = b.option(bool, "pine", "Use PineTime GPIO layout") orelse false;

    exe.setTarget(try std.zig.CrossTarget.parse(.{
        .arch_os_abi = "thumb-freestanding-eabi",
        .cpu_features = "cortex_m4",
    }));

    exe.setBuildMode(.ReleaseSmall);
    exe.strip = true;
    exe.setLinkerScriptPath("src/link.ld");
    exe.addBuildOption(bool, "use_pine_gpio", gpio_layout);
    exe.install();

    const bin = b.step("bin", "build binary file");
    bin.dependOn(&exe.step);
    bin.dependOn(&b.addSystemCommand(&[_][]const u8{
        "llvm-objcopy",
        "-I",
        "elf32-littlearm",
        "-O",
        "binary",
        "zig-cache/bin/ztime.elf",
        "ztime.bin",
    }).step);

    const ihex = b.step("ihex", "build ihex file");
    ihex.dependOn(bin);
    ihex.dependOn(&b.addSystemCommand(&[_][]const u8{
        "objcopy",
        "-I",
        "binary",
        "-O",
        "ihex",
        "ztime.bin",
        "ztime.ihex",
    }).step);

    var main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
