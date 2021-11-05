const std = @import("std");
const pine = @import("lib.zig");


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

pub fn readIdentification() Identification {
    var cmd = [_]u8 { 0x9F, 0, 0, 0 };
    var data = [_]u8 { 0, 0, 0, 0 };
    wakeUp();
    spiMaster.read(@intCast(u32, @ptrToInt(&cmd)), 4, @intCast(u32, @ptrToInt(&data)), 4);

    var id = Identification {
        .manufactureId = data[1],
        .memoryType = data[2],
        .capacity = 0
    }; 

    while (true) {
    if(data[1] == 0x0B) { break; }
    }
    while (true) {
    if(data[2] == 0x40) { break; }
    }

    return id;
}

pub fn readDataBytes(address: u24, len: u8) []u8 {
    var cmd: []u8 = undefined;
    cmd = cmd[0..(4 + len)];
    cmd[0] = 0x03;
    cmd[1] = @intCast(u8, address >> 16);
    cmd[2] = @intCast(u8, address >> 8);
    cmd[3] = @intCast(u8, address & 0xff);
    
    var data: []u8 = undefined;
    data = data[0..(4 + len)];
    spiMaster.read(@intCast(u32, @ptrToInt(&cmd)), len + 4, @intCast(u32, @ptrToInt(&data)), len + 4);

    return data[4..data.len];
}
pub fn writeEnable() void {
    var cmd: u8 = 0x06;
    spiMaster.write(cmd);
}
pub fn pageProgram(address: u24, data: []u8) void {
    var cmd: u8 = 0x02;
    writeEnable();
    spiMaster.write(cmd);
    spiMaster.write(@truncate(u8, address >> 16));
    spiMaster.write(@truncate(u8, address >> 8));
    spiMaster.write(@truncate(u8, address));
    spiMaster.writeBytes(data);
}
pub fn sectorErase(address: u24) void {
    var cmd: u8 = 0x20;
    writeEnable();
    spiMaster.write(cmd);
    spiMaster.write(@truncate(u8, address >> 16));
    spiMaster.write(@truncate(u8, address >> 8));
    spiMaster.write(@truncate(u8, address));
}
//sectorerase
//blockerase
pub fn blockErase32(address: u24) void {
    var cmd: u8 = 0x52;
    writeEnable();
    spiMaster.write(cmd);
    spiMaster.write(@truncate(u8, address >> 16));
    spiMaster.write(@truncate(u8, address >> 8));
    spiMaster.write(@truncate(u8, address));
}

pub fn blockErase64(address: u24) void {
    var cmd: u8 = 0xD8;
    writeEnable();
    spiMaster.write(cmd);
    spiMaster.write(@truncate(u8, address >> 16));
    spiMaster.write(@truncate(u8, address >> 8));
    spiMaster.write(@truncate(u8, address));
}
//chiperase
pub fn chipErase(address: u24) void {
    var cmd: u8 = 0x60;
    writeEnable();
    spiMaster.write(cmd);
    spiMaster.write(@truncate(u8, address >> 16));
    spiMaster.write(@truncate(u8, address >> 8));
    spiMaster.write(@truncate(u8, address));
}

test "semantic-analysis" {
    @import("std").testing.refAllDecls(@This());
}
