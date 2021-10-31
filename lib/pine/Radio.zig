//! 2.4 GHz Radio

pub const Radio = @This();

const base = 0x40001000;

pub fn tx(radio: Radio) void {
    _ = radio;
    const address = @intToPtr(*volatile u32, base);
    address.* = 1;
}

pub fn rx(radio: Radio) void {
    _ = radio;
    const offset = 0x004;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 1;
}

pub fn start(radio: Radio) void {
    _ = radio;
    const offset = 0x008;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 1;
}

pub fn stop(radio: Radio) void {
    _ = radio;
    const offset = 0x00c;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 1;
}

pub fn disable(radio: Radio) void {
    _ = radio;
    const offset = 0x010;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 1;
}

pub fn startRssi(radio: Radio) void {
    _ = radio;
    const offset = 0x018;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 1;
}

pub fn stopRssi(radio: Radio) void {
    _ = radio;
    const offset = 0x018;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 1;
}

pub fn startBitCounter(radio: Radio) void {
    _ = radio;
    const offset = 0x01c;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 1;
}

pub fn stopBitCounter(radio: Radio) void {
    _ = radio;
    const offset = 0x020;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 1;
}

test "semantic-analysis" {
    @import("std").testing.refAllDecls(@This());
}
