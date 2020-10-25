const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("ztime", "src/main.zig");
    exe.setTarget(try std.zig.CrossTarget.parse(.{
        .arch_os_abi = "thumb-freestanding",
        .cpu_features = "cortex_m4",
    }));
    exe.setBuildMode(.ReleaseSmall);
    exe.strip = true;
    exe.setLinkerScriptPath("src/link.ld");
    exe.install();

    var main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}