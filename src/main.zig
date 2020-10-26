const std = @import("std");
const pine = @import("lib.zig");

comptime {
    // force a reference to start code
    _ = @import("start.zig");
}

pub fn main() noreturn {
    const led = pine.GpioPin.p0_17;
    const timer = pine.Timer.timer0;

    while (true) {
        led.config(.{
            .direction = .output,
            .input = .disconnect,
            .pull = .disabled,
            .drive = .s0s1,
            .sense = .disabled,
        });

        timer.config(.{ .mode = 0 });
        timer.config(.{ .bitmode = 3 });
        timer.config(.{ .prescaler = 0 });
        timer.config(.{ .cc_0 = 0 });
        timer.config(.{ .compare_0 = 0 });
        timer.config(.clear);
        timer.config(.start);
        while (@intToPtr(*volatile u32, @enumToInt(timer) + @enumToInt(pine.Timer.TimerConfig.compare_0)).* == 0) {}

        pine.Gpio.set(.{ .p0_17 = true });

        timer.config(.{ .mode = 0 });
        timer.config(.{ .bitmode = 3 });
        timer.config(.{ .prescaler = 0 });
        timer.config(.{ .cc_0 = 0 });
        timer.config(.{ .compare_0 = 0 });
        timer.config(.clear);
        timer.config(.start);
        while (@intToPtr(*volatile u32, @enumToInt(timer) + @enumToInt(pine.Timer.TimerConfig.compare_0)).* == 0) {}
    }
}
