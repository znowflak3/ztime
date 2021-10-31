const std = @import("std");
const pine = @import("lib.zig");

pub const Command = enum(u8) {
    swreset = 0x01,
    slpout = 0x11,
    noron = 0x13,
    invon = 0x21,
    dispon = 0x29,
    caset = 0x2a,
    raset = 0x2b,
    ramwr = 0x2c,
    vscrdef = 0x33,
    colmod = 0x3a,
    madctl = 0x36,
    vscsad = 0x37,
};

const spiMaster = pine.SpiMaster{
    .spim = pine.Spim.spim0,
    .ssPin = pine.GpioPin.spi_ce,
    .chipSelect = pine.Gpio { .spi_ce = true },
};

pub fn init() void {

    spiMaster.init(
        .{ .pin = 2 },
        .{ .pin = 3 },
        .{ .pin = 4 },
        pine.Spim.Frequency.m8,
        .{ .order = false, .cpha = true, .cpol = false },
    );

}

pub fn wakeUp() void {
    var cmd: u8 = 0xAB;
    spiMaster.write(cmd);
    pine.Delay.delay(1000 * pine.Delay.ms);
}

pub const Identification = struct {
    manufactureId: u8,
    memoryType: u8,
    capacity: u8,
};

pub fn readIdentification() void {
    var cmd = [_]u8 { 0x9F, 0, 0, 0, 0 };
    var data = [_]u8 { 0, 0, 0, 0, 0 };
    wakeUp();
    spiMaster.read(@intCast(u32, @ptrToInt(&cmd)), 5, @intCast(u32, @ptrToInt(&data)), 5);

    while (true) {
    if(data[1] == 0x0B) { break; }
    }
    while (true) {
    if(data[2] == 0x40) { break; }
    }
}

test "semantic-analysis" {
    @import("std").testing.refAllDecls(@This());
}