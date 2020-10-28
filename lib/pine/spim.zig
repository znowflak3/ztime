const std = @import("std");
const pine = @import("lib.zig");
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

    pub const SpimEvent = enum(u32) {
        stopped = 0x104,
        endrx = 0x110,
        end = 0x118,
        endtx = 0x120,
        started = 0x14C,
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
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
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

        _unused6: u1 = 0,
    };

    pub fn setInterrupt(spim: Spim, cfg: Interrupt) void {
        const offset = 0x304;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @bitCast(u24, cfg);
    }

    pub fn clearInterrupt(spim: Spim, cfg: Interrupt) void {
        const offset = 0x308;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @bitCast(u24, cfg);
    }

    pub const SpimEnable = enum(u32) {
        disabled = 0,
        enabled = 7,
    };

    pub fn enable(spim: Spim, cfg: SpimEnable) void {
        const offset = 0x500;
        const address = @intToPtr(*volatile u32, @enumToInt(spim) + offset);
        address.* = @enumToInt(cfg);
    }

    pub const PinSelect = packed struct {
        pin: u4 = 0,

        _unused1: u27 = 0,

        connect: bool = false,
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

    pub const Frequency = enum(u32) {
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

    pub const List = enum(u32) {
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

    test "semantic-analysis" {
        @import("std").testing.refAllDecls(@This());
    }
};

pub const SpiMaster = struct {
    spim: Spim,
    ssPin: pine.GpioPin,

    pub fn init(sck: Spim.PinSelect, mosi: Spim.PinSelect, freq: Spim.Frequency, cfg: Spim.Config) void {
        ssPin.config(.{
            .direction = .output,
            .input = .disconnect,
            .pull = .disabled,
            .drive = .s0s1,
            .sense = .disabled,
        });

        pine.Gpio.set(.{.tp_int});

        spim.selectSckPin(sck);
        spim.selectMosiPin(mosi);
        spim.setFrequency(freq);
        spim.config(cfg);

        spim.clearEvent(.stopped);
        spim.clearEvent(.endrx);
        spim.clearEvent(.end);
        spim.clearEvent(.endtx);
        spim.clearEvent(.started);

        spim.enable(.enabled);
    }

    pub fn prepareTx(buffer: u32, size: u8) void {
        spim.setTxdDataPtr(buffer);
        spim.setTxdMaxCount(size);
        spim.setTxtList(.disabled);
        spim.clearEvent(.end);
    }

    pub fn write(data: u8, size: u8) void {
        const bufferAddress = &data;
        const bufferSize = size;

        prepareTx(spim, bufferAddress, size);

        pine.Gpio.clear(.{.tp_int});

        spim.startTx();
        while (spim.readEvent(.end) == 0) {}

        pine.Gpio.set(.{.tp_int});

        spim.clearEvent(.end);
    }
    test "semantic-analysis" {
        @import("std").testing.refAllDecls(@This());
    }
};

pub const ms = @round(1000 / 0.0633);

pub fn delay(ticks: u32) void {
    const timer = pine.Timer.timer0;

    timer.clearEvent(.event_0);
    timer.setBitMode(.b32);
    timer.setPrescaler(0);
    timer.setCaptureCompare(.cc_0, ticks);
    timer.clear();
    timer.start();
    while (timer.readEvent(.event_0) == 0) {}
}

test "semantic-analysis" {
    @import("std").testing.refAllDecls(@This());
}
