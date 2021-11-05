const std = @import("std");
const pine = @import("pine");

pub export fn main() void {
    const norFlash = pine.SpiNorFlash;
    norFlash.init();
    norFlash.readIdentification();
    
    const lcd = pine.ST7789;
    lcd.init();

    //15x15 0x4444
    var data = [_]u8{ 0x44 } ** ((5 * 5) * 2);
    //Write square To display and then to memory
    //lcd.writeToScreen(0, 0, 4, 4, data[0..data.len]);
    
    norFlash.pageProgram(0, data[0..data.len]);
    pine.Delay.delay(1000 * pine.Delay.ms);
    //readfrom memory and write to display but next to the other square
    var recievedData = norFlash.readDataBytes(0, data.len);
    lcd.writeToScreen(5, 5, 14, 14, recievedData);
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
