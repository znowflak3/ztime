const std = @import("std");
const testing = std.testing;

const Color = packed struct { red: u5, green: u6, blue: u5 };

// TODO: abstract over development board
const Gpio = packed struct {
    xl1: bool = false,
    xl2: bool = false,
    spi_sck: bool = false,
    spi_mosi: bool = false,
    spi_miso: bool = false,
    spi_ce: bool = false,
    bma421_sda: bool = false,
    bma421_scl: bool = false,
    bma421_int: bool = false,
    lcd_det: bool = false,
    tp_reset: bool = false,
    p0_11: bool = false,
    charge_indication: bool = false,
    push_button_in: bool = false,
    lcd_backlight_low: bool = false,
    push_button_out: bool = false,
    vibrator_out: bool = false,
    p0_17: bool = false,
    lcd_rs: bool = false,
    power_presence_indication: bool = false,
    traceclk: bool = false,
    n_reset: bool = false,
    lcd_backlight_mid: bool = false,
    lcd_backlight_high: bool = false,
    power_control_3v3: bool = false,
    lcd_cs: bool = false,
    lcd_reset: bool = false,
    status_led: bool = false,
    tp_int: bool = false,
    ain5: bool = false,
    hrs3300_test: bool = false,
    battery_voltage: bool = false,

    const gpio_set_address = @intToPtr(*volatile u32, 0x50000508);
    const gpio_clear_address = @intToPtr(*volatile u32, 0x5000050c);

    /// Set given GPIO pins (set to high)
    fn set(self: Gpio) void {
        gpio_set_address.* = @bitCast(u32, self);
    }

    /// Clear given GPIO pins (set to low)
    fn clear(self: Gpio) void {
        gpio_clear_address.* = @bitCast(u32, self);
    }
};

const GpioPin = enum(u32) {
    //! GPIO configuration addresses

    xl1 = 0x50000700,
    xl2 = 0x50000704,
    spi_sck = 0x50000708,
    spi_mosi = 0x5000070C,
    spi_miso = 0x50000710,
    spi_ce = 0x50000714,
    bma421_sda = 0x50000718,
    bma421_scl = 0x5000071C,
    bma421_int = 0x50000720,
    lcd_det = 0x50000724,
    tp_reset = 0x50000728,
    p0_11 = 0x5000072C,
    charge_indication = 0x50000730,
    push_button_in = 0x50000734,
    lcd_backlight_low = 0x50000738,
    push_button_out = 0x5000073C,
    vibrator_out = 0x50000740,
    p0_17 = 0x50000744,
    lcd_rs = 0x50000748,
    power_presence_indication = 0x5000074C,
    traceclk = 0x50000750,
    n_reset = 0x50000754,
    lcd_backlight_mid = 0x50000758,
    lcd_backlight_high = 0x5000075C,
    power_control_3v3 = 0x50000760,
    lcd_cs = 0x50000764,
    lcd_reset = 0x50000768,
    status_led = 0x5000076C,
    tp_int = 0x50000770,
    ain5 = 0x50000774,
    hrs3300_test = 0x50000778,
    battery_voltage = 0x5000077C,

    pub const GpioPinConfig = packed struct {
        dir: packed enum(u1) { input, output },
        input: packed enum(u1) { connect, disconnect },
        pull: packed enum(u2) { disabled, pulldown, pullup },
        unused1: u4 = 0,
        drive: packed enum(u3) {
            s0s1,
            h0s1,
            s0h1,
            h0h1,
            d0s1,
            s0d1,
            h0d1,
        },
        unused2: u5 = 0,
        sense: packed enum(u2) { disabled, high, low },
        unused3: u14 = 0,
    };

    pub fn config(self: GpioPin, cfg: GpioPinConfig) void {
        const address = @intToPtr(*volatile u32, @enumToInt(self));
        address.* = @bitCast(u32, cfg);
    }
};

const HighFrequencyClock = struct {};

const LowFrequencyClock = struct {};

const Cmd = enum {
    swreset = 0x01,
    slpout = 0x11,
    noron = 0x13,
    invon = 0x21,
    dispon = 0x29,
    caset = 0x2A,
    raset = 0x2B,
    ramwr = 0x2C,
    vscrdef = 0x33,
    colmod = 0x3A,
    madctl = 0x36,
    vscsad = 0x37,
};

const SpiConfig = enum {
    reset_pin = 30,
    sck_pin = 4,
    mosi_pin = 3,
    miso_pin = 255,
    ss_pin = 28,
    dcx_pin = 29,
};

const IsrHandler = fn () callconv(.C) void;
export const irs_vectors linksection(".isr_vector") = [_]IsrHandler{
    resetHandler,
    nmiHandler,
    hardFaultHandler,
    memManageHAndler,
    busFaultHandler,
    usageFaultHandler,
    @intToPtr(IsrHandler, 4),
    @intToPtr(IsrHandler, 4),
    @intToPtr(IsrHandler, 4),
    @intToPtr(IsrHandler, 4),
    svcHandler,
    debugMonHandler,
    @intToPtr(IsrHandler, 4),
    pendSvHanlder,
    sysTickHandler,
};

fn defaultHandler() callconv(.C) void {
    @breakpoint();
    while (true) {}
}

const resetHandler = defaultHandler;
const nmiHandler = defaultHandler;
const hardFaultHandler = defaultHandler;
const memManageHAndler = defaultHandler;
const busFaultHandler = defaultHandler;
const usageFaultHandler = defaultHandler;
const svcHandler = defaultHandler;
const debugMonHandler = defaultHandler;
const pendSvHanlder = defaultHandler;
const sysTickHandler = defaultHandler;

/// Pine memory
const ram = @intToPtr(*align(16) volatile [0x5000]u8, 0x2000_0000);

/// Entry point to the program as defined within the linker script
export fn init() noreturn {
    @call(.{ .stack = ram[0..0x800] }, main, .{});
    while (true) {}
}

fn main() void {
    const output = .{
        .dir = .output,
        .input = .disconnect,
        .pull = .disabled,
        .drive = .s0s1,
        .sense = .disabled,
    };

    GpioPin.config(.p0_17, output);
}
