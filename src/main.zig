const std = @import("std");
const pine = @import("lib.zig");

comptime {
    // force a reference to start code
    _ = @import("start.zig");
}

pub export fn main() void {
    const led = pine.GpioPin.p0_17;

    led.config(.{
        .direction = .output,
        .input = .disconnect,
        .pull = .disabled,
        .drive = .s0s1,
        .sense = .disabled,
    });
}

test "semantic-analysis" {
    @import("std").testing.refAllDecls(@This());
}
