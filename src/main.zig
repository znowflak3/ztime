const std = @import("std");
const pine = @import("pine");

pub export fn main() void {
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
        pine.Gpio.clear(.{ .p0_17 = true });

        timer.setPrescaler(0);
        timer.setBitMode(.b32);
        timer.setMode(.timer);
        timer.setCaptureCompare(.cc_0, 1000);
        timer.clearEvent(.event_0);
        timer.clear();
        timer.start();

        while (timer.readEvent(.event_0) == 0) {}

        pine.Gpio.set(.{ .p0_17 = true });

        timer.setPrescaler(0);
        timer.setBitMode(.b32);
        timer.setMode(.timer);
        timer.setCaptureCompare(.cc_0, 1000);
        timer.clearEvent(.event_0);
        timer.clear();
        timer.start();

        while (timer.readEvent(.event_0) == 0) {}
    }
}

test "semantic-analysis" {
    @import("std").testing.refAllDecls(@This());
}
