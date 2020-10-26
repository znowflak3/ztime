pub const Timer = enum(u32) {
    timer0 = 0x40008000,
    timer1 = 0x40009000,
    timer2 = 0x4000a000,
    timer3 = 0x4001a000,
    timer4 = 0x4001b000,

    pub const TimerConfig = union(enum(u24)) {
        start = 0x000,
        stop = 0x004,
        increment = 0x008,
        clear = 0x00c,

        capture_0 = 0x010,
        capture_1 = 0x040,
        capture_2 = 0x044,
        capture_3 = 0x04c,
        capture_4 = 0x050,
        capture_5 = 0x054,

        compare_0: u32 = 0x140,
        compare_1: u32 = 0x144,
        compare_2: u32 = 0x148,
        compare_3: u32 = 0x14c,
        compare_4: u32 = 0x150,
        compare_5: u32 = 0x154,

        shortcut: Shortcut = 0x200,
        interrupt_enable: Interrupt = 0x304,
        interrupt_disable: Interrupt = 0x308,
        mode: u32 = 0x504,
        bitmode: u32 = 0x508,
        prescaler: u32 = 0x510,

        cc_0: u32 = 0x540,
        cc_1: u32 = 0x544,
        cc_2: u32 = 0x548,
        cc_3: u32 = 0x54c,
        cc_4: u32 = 0x550,
        cc_5: u32 = 0x554,

        pub const Shortcut = packed struct {
            compare_clear_0: bool = false,
            compare_clear_1: bool = false,
            compare_clear_2: bool = false,
            compare_clear_3: bool = false,
            compare_clear_4: bool = false,
            compare_clear_5: bool = false,

            _unused1: u2 = 0,

            compare_stop_0: bool = false,
            compare_stop_1: bool = false,
            compare_stop_2: bool = false,
            compare_stop_3: bool = false,
            compare_stop_4: bool = false,
            compare_stop_5: bool = false,
            _unused2: u2 = 0,
            _unused21: u16 = 0,
        };

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
    };

    pub fn config(timer: Timer, cfg: TimerConfig) void {
        const address = @intToPtr(*volatile u32, @enumToInt(timer) + @enumToInt(cfg));
        switch (cfg) {
            .start,
            .stop,
            .increment,
            .clear,
            .capture_0,
            .capture_1,
            .capture_2,
            .capture_3,
            .capture_4,
            .capture_5,
            => address.* = 1,

            .shortcut => |settings| address.* = @bitCast(u32, settings),

            .interrupt_enable,
            .interrupt_disable,
            => |settings| address.* = @bitCast(u32, settings),

            .mode,
            .bitmode,
            .prescaler,
            .cc_0,
            .cc_1,
            .cc_2,
            .cc_3,
            .cc_4,
            .cc_5,
            .compare_0,
            .compare_1,
            .compare_2,
            .compare_3,
            .compare_4,
            .compare_5,
            => |settings| address.* = settings,
        }
    }
};
