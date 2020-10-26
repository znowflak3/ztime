const std = @import("std");
const pine = @import("lib.zig");

comptime {
    // force a reference to start code
    _ = @import("start.zig");
}

pub fn main() noreturn {
    const led = pine.GpioPin.p0_17;
    const timer = pine.Timer.timer0;

    led.config(.{
        .direction = .output,
        .input = .disconnect,
        .pull = .disabled,
        .drive = .s0s1,
        .sense = .disabled,
    });

    while (true) {
        timer.setMode(.timer);
        timer.setBitMode(.b32);
        timer.setPrescaler(0);
        timer.setCaptureCompare(.cc_0, 500);
        timer.clearEvent(.event_0);
        timer.clear();
        timer.start();
        pine.Gpio.set(.{ .p0_17 = true });

        timer.setMode(.timer);
        timer.setBitMode(.b32);
        timer.setPrescaler(0);
        timer.setCaptureCompare(.cc_0, 500);
        timer.clearEvent(.event_0);
        timer.clear();
        timer.start();
        pine.Gpio.set(.{ .p0_17 = false });
    }
}
