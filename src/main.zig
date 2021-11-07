const std = @import("std");
const pine = @import("pine");

pub export fn main() void {
    const norFlash = pine.SpiNorFlash;
    norFlash.init();
    var id = norFlash.readIdentification();
    _ = id;
    
    const lcd = pine.ST7789;
    lcd.init();
    
    //var manIdDec = pine.Font.decimal(id.manufactureId);

    const tens = pine.Font.sans_serif_30x60_get_number(2);
    lcd.writeToScreen16(30, 0, 59, 59, tens);
    const ones = pine.Font.sans_serif_30x60_get_number(2);
    lcd.writeToScreen16(60, 0, 89, 59, ones);
    
    //lcd.writeToScreen(30, 0, 59, 59, std.mem.bytesAsSlice(u8, pine.Font.sans_serif_30x60_get_number(manIdDec.tens)));
    //var dmaData = [_]u8{0x44} ** 250;
    //var bgData = [_]u8{0x00} ** 250;
    //var rData: [250]u8 = undefined;
    //lcd.setAddressWindow(0, 0, 7, 7);
    //lcd.writeToScreenDma(0, 0, 7, 7, &dmaData);
    

    //Write square To display and then to memory
    //lcd.writeToScreenDma(0, 0, 7, 7, &bgData);
    //norFlash.sectorErase(0);
    //norFlash.pageProgram(0, &bgData);
    //pine.Delay.delay(5000 * pine.Delay.ms);
    //readfrom memory and write to display but next to the other square
    //lcd.writeToScreenDma(8, 8, 16, 16, &rData);
    //norFlash.readDataBytes(0, &rData);
    //lcd.writeToScreenDma(0, 0, 7, 7, &rData);
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
