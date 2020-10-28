const std = @import("std");
const pine = @import("pine");

pub export fn main() void {
    const spiMaster = pine.SpiMaster{
        .spim = pine.Spim.spim0,
        .ssPin = pine.GpioPin.tp_int,
    };

    const screenSizeX: u16 = 240;
    const screenSezeY: u16 = 240;

    const resetPin = pine.GpioPin.hrs3300_test; //30
    const dcPin = pine.GpioPin.ain5; //29

    resetPin.config(.{
        .direction = .output,
        .input = .disconnect,
        .pull = .disabled,
        .drive = .s0s1,
        .sense = .disabled,
    });
    dcPin.config(.{
        .direction = .output,
        .input = .disconnect,
        .pull = .disabled,
        .drive = .s0s1,
        .sense = .disabled,
    });

    spiMaster.init(.{ .pin = 4 }, .{ .pin = 3 }, pine.Spim.Frequency.m8, .{ .order = true, .cpha = true, .cpol = true });

    pine.Delay.delay(50 * pine.Delay.ms);

    //hw reset
    pine.Gpio.clear(.{ .hrs3300_test = true });

    pine.Delay.delay(15 * pine.Delay.ms);

    pine.Gpio.set(.{ .ain5 = true });

    pine.Delay.delay(2 * pine.Delay.ms);

    //set command
    pine.Gpio.clear(.{ .ain5 = true });
    var a: u8 = 0x01;
    spiMaster.write(a, 1);

    //set data
    pine.Gpio.set(.{ .ain5 = true });
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
