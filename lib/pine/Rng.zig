const Rng = @This();

const base = 0x4000d000;

pub fn start(rng: Rng) void {
    _ = rng;
    const address = @intToPtr(*volatile u32, base);
    address.* = 1;
}

pub fn stop(rng: Rng) void {
    _ = rng;
    const offset = 0x004;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 1;
}

pub const Interrupt = enum { disabled, enabled };

pub fn interrupt(rng: Rng, cfg: Interrupt) void {
    _ = rng;
    const offset: u32 = switch (cfg) {
        .enabled => 0x304,
        .disabled => 0x308,
    };
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 1;
}

// TODO
pub fn shortcut(rng: Rng, sc: bool) void {
    _ = rng;
    const offset = 0x100;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = @boolToInt(sc);
}

pub const Bias = enum { disabled, enabled };

pub fn bias(b: Bias) void {
    _ = b;
    const offset = 0x504;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = @enumToInt(b);
}

pub fn read(rng: Rng) u8 {
    _ = rng;
    const offset = 0x508;
    const address = @intToPtr(*volatile u32, base + offset);
    return @truncate(u8, address.*);
}

test "semantic-analysis" {
    @import("std").testing.refAllDecls(@This());
}
