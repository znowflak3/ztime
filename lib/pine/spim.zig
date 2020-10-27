const std = @import("std");
const expect = std.testing.expect;

pub const Spim = enum(u32) {
    spim0 = 0x40003000,
    spim1 = 0x40004000,
    spim2 = 0x40023000,

    pub fn startTx(spim: Spim) void {
        const offset = 0x010;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = 1;
    }

    pub fn stopTx(spim: Spim) void {
        const offset = 0x014;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = 1;
    }

    pub fn suspendTx(spim: Spim) void {
        const offset = 0x01C;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = 1;
    }

    pub fn resumeTx(spim: Spim) void {
        const offset = 0x020;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = 1;
    }

    pub const SpimEvent = enum (u32) {
        event_stopped = 0x104,
        event_endrx = 0x110,
        event_end = 0x118,
        event_endtx = 0x120,
        event_started = 0x14C,
    };

    pub fn clearEvent(spim: Spim, event: SpimEvent) void {
        const offset = @enumToInt(event);
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = 0;
    }

    pub fn readEvent(spim: Spim, event: SpimEvent) u32 {
        const offset = @enumToInt(event);
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        return address.*;
    }

    pub const Shortcut = packed struct {
        _unused1: u17 = 0,

        end_start: bool = false,

        _unused2: u14 = 0,
    };

    pub fn shortcut(spim: Spim, short: Shortcut) void {
        const offset = 0x200;
        const address = @intToPtr(*volatile u32, @enumToInt(spim0) + offset);
        address.* = @bitCast(u32, short);
    }

    pub const Interrupt = packed struct {
        _unused1: u1 = 0,

        stopped: bool = false,

        _unused2: u2 = 0,

        endrx: bool = false,

        _unused3: u1 = 0,

        end: bool = false,

        _unused4: u1 = 0,

        endtx: bool = false,

        _unused5: u10 = 0,

        started: bool = false,

        _unused6: u12 = 0,
    };

    pub fn setInterrupt(spim: Spim, cfg: Interrupt) void {
        const offset = 0x304;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @bitCast(u32, cfg);
    }

    pub fn clearInterrupt(spim: Spim, cfg: Interrupt) void {
        const offset = 0x308;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @bitCast(u32, cfg);
    }

    pub const Enable = enum (u32) {
        disabled = 0,
        enabled = 7,
    };

    pub fn enable(spim: Spim, cfg: Enable) void {
        const offset = 0x500;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @enumToInt(cfg);
    }

    pub const PinSelect = packed struct {
        pin: u4 = 0,

        _unused1: u27 = 0,

        connect: bool = 0,
    };

    pub fn selectSckPin(spim: Spim, cfg: PinSelect) void {
        const offset = 0x508;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @bitCast(u32, cfg);
    }

    pub fn selectMosiPin(spim: Spim, cfg: PinSelect) void {
        const offset = 0x50C;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @bitCast(u32, cfg);
    }

    pub fn selectMisoPin(spim: Spim, cfg: PinSelect) void {
        const offset = 0x510;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @bitCast(u32, cfg);
    }

    pub const Frequency = enum (u32) {
        k125 = 0x02000000,
        k250 = 0x04000000,
        k500 = 0x08000000,
        m1 = 0x10000000,
        m2 = 0x20000000,
        m4 = 0x40000000,
        m8 = 0x80000000,
    };

    pub fn setFrequency(spim: Spim, frequency: Frequency) void {
        const offset = 0x523;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @enumToInt(frequency);
    }

    pub fn setRxdDataPtr(spim: Spim, dataPtr: *u32) void {
        const offset = 0x354;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = dataPtr;
    }

    pub fn setTxdDataPtr(spim: Spim, dataPtr: *u32) void {
        const offset = 0x544;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = dataPtr;
    }

    pub fn setRxdMaxcount(spim: Spim, count: u8) void {
        const offset = 0x358;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        const val: u32 = count;
        address.* = val;
    }

    pub fn setTxdMaxcount(spim: Spim, count: u8) void {
        const offset = 0x548;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        const val: u32 = count;
        address.* = val;
    }

    pub fn readRxdAmount(spim: Spim) u8 {
        const offset = 0x53C;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        const amount: u8 = address.*;
        return amount;
    }

    pub fn readTxdAmount(spim: Spim) u8 {
        const offset = 0x54C;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        const amount: u8 = address.*;
        return amount;
    }
. If
    pub const List = enum (u32) {
        disabled = 0,
        arrayList = 1,
    };

    pub fn setRxdList(spim: Spim, list: List) void {
        const offset = 0x540;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @enumToInt(list);
    }

    pub fn setTxdList(spim: Spim, list: List) void {
        const offset = 0x550;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @enumToInt(list);
    }

    pub const Config = packed struct {
        order: bool = false,
        cpha: bool = false,
        cpol: bool = false,

        _unused1: u29 = 0,
    };

    pub fn config(spim: Spim, cfg: Config) void {
        const offset = 0x544;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @bitCast(u32, cfg);
    }

    pub fn readOrc(spim: Spim, value: u8) u32 {
        const offset = 0x5C0;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        return address.*;
    }

    pub fn writeOrc(spim: Spim, value: u8) void {
        const offset = 0x5C0;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        const val: u32 = value;
        address.* = val;
    }

};


test "test1" {
    const count: u8 = 5;
    const val: u32 = count;
    const T = @TypeOf(count);
    expect(T == u8);
}