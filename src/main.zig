const std = @import("std");
const pine = @import("lib.zig");

comptime {
    _ = @import("start.zig");
}

pub fn main() void {
    const led: pine.gpio.GpioPin = .p0_17;

    led.config(.{
        .direction = .output,
        .input = .disconnect,
        .pull = .disabled,
        .drive = .s0s1,
        .sense = .disabled,
    });
}
