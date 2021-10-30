const std = @import("std");
const pine = @import("pine");

pub export fn main() void {
    const norFlash = pine.SpiNorFlash;
    norFlash.init();
    norFlash.readIdentification();
    
    const lcd = pine.ST7789;
    lcd.init();
}

pub export fn mainTwo() void {
    const led = pine.GpioPin.p0_17;
    const timer = pine.Timer.timer0;

    led.config(.{
        .direction = .output,
        .input = .disconnect,
        .pull = .disabled,
        .drive = .s0s1,
        .sense = .disabled,
    });

    const second: u32 = @round((1000.0 / 0.0625) * 1000.0);

    while (true) {
        pine.Gpio.set(.{ .p0_17 = true });

        timer.clearEvent(.event_0);
        timer.setBitMode(.b32);
        timer.setPrescaler(0);
        timer.setCaptureCompare(.cc_0, second);
        timer.clear();
        timer.start();
        while (timer.readEvent(.event_0) == 0) {}

        pine.Gpio.clear(.{ .p0_17 = true });

        timer.clearEvent(.event_0);
        timer.setBitMode(.b32);
        timer.setPrescaler(0);
        timer.setCaptureCompare(.cc_0, second);
        timer.clear();
        timer.start();
        while (timer.readEvent(.event_0) == 0) {}
    }
}

test "semantic-analysis" {
    @import("std").testing.refAllDecls(@This());
}
