
const std = @import("std");
const pine = @import("lib.zig");
const SpiMaster = @This();

spim: pine.Spim,
ssPin: pine.GpioPin,
chipSelect: pine.Gpio,

pub fn init(self: SpiMaster, sck: pine.Spim.PinSelect, mosi: pine.Spim.PinSelect, miso: pine.Spim.PinSelect, freq: pine.Spim.Frequency, cfg: pine.Spim.Config) void {
    self.ssPin.config(.{
        .direction = .output,
        .input = .disconnect,
        .pull = .disabled,
        .drive = .s0s1,
        .sense = .disabled,
    });

    self.chipSelect.set();
    self.chipSelect.clear();

    self.spim.selectSckPin(sck);
    self.spim.selectMosiPin(mosi);
    self.spim.selectMisoPin(miso);
    self.spim.setFrequency(freq);
    self.spim.config(cfg);

    self.spim.clearEvent(.stopped);
    self.spim.clearEvent(.endrx);
    self.spim.clearEvent(.end);
    self.spim.clearEvent(.endtx);
    self.spim.clearEvent(.started);

    self.spim.enable(.enabled);
}

pub fn prepareTx(self: SpiMaster, buffer: u32, size: u8) void {
    //self.spim.setTxdDataPtr(buffer);
    self.spim.setTxdList(.disabled);
    self.spim.setTxdMaxcount(size);
    self.spim.setTxdDataPtr(buffer);
    self.spim.clearEvent(.end);
}

pub fn prepareTxList(self: SpiMaster, buffer: u32, size: u8) void {
    self.spim.setTxdDataPtr(buffer);
    self.spim.setTxdMaxcount(size);
    self.spim.setTxdList(.arrayList);
    self.spim.clearEvent(.end);
}

pub fn prepareRx(self: SpiMaster, buffer: u32, size: u8) void {
    self.spim.setRxdDataPtr(buffer);
    self.spim.setRxdMaxcount(size);
    self.spim.setRxdList(.disabled);
    self.spim.clearEvent(.end);
}

pub fn prepareRxList(self: SpiMaster, buffer: u32, size: u8) void {
    self.spim.setRxdDataPtr(buffer);
    self.spim.setRxdMaxcount(size);
    self.spim.setRxdList(.arrayList);
    self.spim.clearEvent(.end);
}

pub fn write(self: SpiMaster, data: u8) void {
    const bufferAddress: u32 = @ptrToInt(&data);

    self.chipSelect.clear();

    self.prepareTx(bufferAddress, 1);
    self.prepareRx(0, 0);
    self.spim.start();
    while (self.spim.readEvent(.end) == 0) {}

    self.chipSelect.set();
    self.spim.clearEvent(.end);
}

pub fn read(self: SpiMaster, cmdAddress: u32, cSize: u8, dataAddress: u32, dSize: u8) void {
    //const cmdAddress: u32 = @intCast(u32, @ptrToInt(&cmd));
    //const dataAddress: u32 = @intCast(u32, @ptrToInt(&data));

    self.chipSelect.clear();

    self.prepareTx(cmdAddress, cSize);
    self.prepareRx(dataAddress, dSize);
    self.spim.start();
    while (self.spim.readEvent(.end) == 0) {}

    self.chipSelect.set();
    self.spim.clearEvent(.end);
}

pub fn writeBytes(self: SpiMaster, data: []const u8) void {
    for (data) |value| {
        self.write(value);
    }
}

pub fn writeBytesDma(self: SpiMaster, data: []const u8) void {
    //for (data) |value| {
    //self.write(value);
    //}i
    //var a: u32 = 0xFFFFFFFF;
    //var b = [_]u32{ 0xFFFFFFFF, 0xFFFFFFFF };
    //const bufferAddress: u32 = @ptrToInt(data.ptr);
    //var magic = [_]u8{ 0xFF, 0xFF, 0xFF, 0xFF } ** 8;

    //self.prepareTx(bufferAddress, @intCast(u8, data.len));

    self.spim.setTxdList(.arrayList);
    self.spim.setTxdMaxcount(@intCast(u8, data.len));
    self.spim.setTxdDataPtr(@ptrToInt(data.ptr));

    self.spim.clearEvent(.end);

    pine.Gpio.clear(.{ .tp_int = true });

    self.spim.startTx();
    while (self.spim.readEvent(.end) == 0) {}

    pine.Gpio.set(.{ .tp_int = true });

    self.spim.clearEvent(.end);
}
test "semantic-analysis" {
    @import("std").testing.refAllDecls(@This());
}
