pub const Timer = enum(u32) {
    timer0 = 0x40008000,
    timer1 = 0x40009000,
    timer2 = 0x4000a000,
    timer3 = 0x4001a000,
    timer4 = 0x4001b000,

    pub const Interrupt = packed struct {
        _unused1: u16 = 0,
        compare_0: bool = false,
        compare_1: bool = false,
        compare_2: bool = false,
        compare_3: bool = false,
        compare_4: bool = false,
        compare_5: bool = false,
        _unused2: u10 = 0,
    };

    pub fn setInterrupt(timer: Timer, cfg: Interrupt) void {
        const offset = 0x304;
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + offset);
        address.* = @bitCast(u32, cfg);
    }

    pub fn clearInterrupt(timer: Timer, cfg: Interrupt) void {
        const offset = 0x308;
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + offset);
        address.* = @bitCast(u32, cfg);
    }

    pub fn start(timer: Timer) void {
        const address = @intToPtr(*volatile u32, @enumToInt(timer));
        address.* = 1;
    }

    pub fn stop(timer: Timer) void {
        const offset = 0x004;
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + offset);
        address.* = 1;
    }

    pub fn increment(timer: Timer) void {
        const offset = 0x008;
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + offset);
        address.* = 1;
    }

    pub fn clear(timer: Timer) void {
        const offset = 0x00c;
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + offset);
        address.* = 1;
    }

    pub const TimerCapture = enum(u32) {
        cc_0 = 0x010,
        cc_1 = 0x040,
        cc_2 = 0x044,
        cc_3 = 0x04c,
        cc_4 = 0x050,
        cc_5 = 0x054,
    };

    pub fn setCapture(timer: Timer, cap: TimerCapture, value: u32) void {
        const offset = @enumToInt(cap);
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + offset);
        address.* = value;
    }

    pub const TimerEvent = enum(u32) {
        event_0 = 0x140,
        event_1 = 0x144,
        event_2 = 0x148,
        event_3 = 0x14c,
        event_4 = 0x150,
        event_5 = 0x154,
    };

    pub fn clearEvent(timer: Timer, event: TimerEvent) void {
        const offset = @enumToInt(event);
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + offset);
        address.* = 0;
    }

    pub const Shortcut = packed struct {
        clear_0: bool = false,
        clear_1: bool = false,
        clear_2: bool = false,
        clear_3: bool = false,
        clear_4: bool = false,
        clear_5: bool = false,

        _unused1: u2 = 0,

        stop_0: bool = false,
        stop_1: bool = false,
        stop_2: bool = false,
        stop_3: bool = false,
        stop_4: bool = false,
        stop_5: bool = false,
        _unused2: u2 = 0,
        _unused21: u16 = 0,
    };

    pub fn set(timer: Timer, short: Shortcut) void {
        const offset = 0x200;
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + offset);
        address.* = @bitCast(u32, short);
    }

    pub const TimerMode = enum(u32) {
        timer = 0,
        counter = 1,
        low_power_counter = 2,
    };

    pub fn setMode(timer: Timer, mode: TimerMode) void {
        const offset = 0x504;
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + offset);
        address.* = @enumToInt(mode);
    }

    pub const TimerBitMode = enum(u32) {
        b16 = 0,
        b8 = 1,
        b24 = 2,
        b32 = 3,
    };

    pub fn setBitMode(timer: Timer, bit: TimerBitMode) void {
        const offset = 0x508;
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + offset);
        address.* = @enumToInt(bit);
    }

    pub fn setPrescaler(timer: Timer, scale: u32) void {
        const offset = 0x510;
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + offset);
        address.* = scale;
    }

    pub const TimerCaptureCompare = enum(u32) {
        cc_0 = 0x540,
        cc_1 = 0x544,
        cc_2 = 0x548,
        cc_3 = 0x54c,
        cc_4 = 0x550,
        cc_5 = 0x554,
    };

    pub fn setCaptureCompare(timer: Timer, cc: TimerCaptureCompare, value: u32) void {
        const offset = @enumToInt(cc);
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + offset);
        address.* = value;
    }
};

pub const TealTimeCounter = void; // TODO
