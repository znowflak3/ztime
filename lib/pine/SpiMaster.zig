const std = @import("std");
const pine = @import("lib.zig");
const SpiMaster = @This();

spim: pine.Spim,
ssPin: pine.GpioPin,

pub fn init(self: SpiMaster, sck: pine.Spim.PinSelect, mosi: pine.Spim.PinSelect, freq: pine.Spim.Frequency, cfg: pine.Spim.Config) void {
    self.ssPin.config(.{
        .direction = .output,
        .input = .disconnect,
        .pull = .disabled,
        .drive = .s0s1,
        .sense = .disabled,
    });

    pine.Gpio.set(.{ .tp_int = true });

    self.spim.selectSckPin(sck);
    self.spim.selectMosiPin(mosi);
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

pub fn write(self: SpiMaster, data: u8) void {
    const bufferAddress: u32 = @ptrToInt(&data);

    self.prepareTx(bufferAddress, 1);

    pine.Gpio.clear(.{ .tp_int = true });

    self.spim.startTx();
    while (self.spim.readEvent(.end) == 0) {}

    pine.Gpio.set(.{ .tp_int = true });

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
    var a: u32 = 0xFFFFFFFF;
    var b = [_]u32{ 0xFFFFFFFF, 0xFFFFFFFF };
    const bufferAddress: u32 = @ptrToInt(data.ptr);
    var magic = [_]u8{ 0xFF, 0xFF, 0xFF, 0xFF } ** 8;

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
