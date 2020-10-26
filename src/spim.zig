pub const Spim = enum(u32) {
    spim0 = 0x40003000,
    spim1 = 0x40004000,
    spim2 = 0x40023000,

    pub const SpimConfig = union(enum(u24)) {
        task_start = 0x010,
        task_stop = 0x014,
        task_suspend = 0x01C,
        task_resume = 0x020,
        event_stopped = 0x104,
        event_endrx = 0x110,
        event_end = 0x118,
        event_endtx = 0x120,
        event_started = 0x14C,
        shorts = 0x200,
        intenset = 0x304,
        intenclr = 0x308,
        enable = 0x500,
        psel_sck = 0x508,
        psel_mosi = 0x50C,
        psel_miso = 0x510,
        frequency = 0x524,
        rxd_ptr = 0x534,
        rxd_maxcnt = 0x538,
        rxd_amount = 0x53C,
        rxd_list = 0x540,
        txd_ptr = 0x544,
        txd_maxcnt = 0x548,
        txd_amount = 0x54C,
        txd_list = 0x550,
        config = 0x554,
        orc = 0x35C0,
    };









};
