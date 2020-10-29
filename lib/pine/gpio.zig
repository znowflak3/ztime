const std = @import("std");
const testing = std.testing;
//const build_options = @import("build_options");

pub const Gpio = packed struct {
    //! GPIO pin state where `false` has no effect and `true` will change the
    //! pin state with the given `set` and `clear` methods.
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

    const base = 0x50000000;

    /// Set the configured pins to low when the pin is true
    pub fn set(self: Gpio) void {
        const offset = 0x508;
        const address = @intToPtr(*volatile u32, base + offset);
        address.* = @bitCast(u32, self);
    }

    /// Set the configured pins to high when the pin is true
    pub fn clear(self: Gpio) void {
        const offset = 0x50c;
        const address = @intToPtr(*volatile u32, base + offset);
        address.* = @bitCast(u32, self);
    }
};

test "gpio-setting" {
    testing.expect(1 << 17 == @bitCast(u32, Gpio{ .p0_17 = true }));
    testing.expect(1 << 11 == @bitCast(u32, Gpio{ .p0_11 = true }));
}

pub const GpioPin = enum(u32) {
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

    pub fn config(pin: GpioPin, cfg: PinConfig) void {
        const address = @intToPtr(*volatile u32, @enumToInt(pin));
        address.* = @bitCast(u32, cfg);
    }
};

pub const PinConfig = packed struct {
    direction: packed enum(u1) { input, output },
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

pub fn MakeGpioPin(comptime pin: GpioPin) type {
    return struct {
        pub inline fn set() void {
            var cfg: Gpio = .{};
            @field(cfg, @tagName(pin)) = true;
            cfg.set();
        }

        pub inline fn clear() void {
            var cfg: Gpio = .{};
            @field(cfg, @tagName(pin)) = true;
            cfg.clear();
        }

        pub fn config(cfg: PinConfig) void {
            const address = @intToPtr(*volatile u32, @enumToInt(pin));
            address.* = @bitCast(u32, cfg);
        }
    };
}

pub const xl1 = MakeGpioPin(0x50000700);
pub const xl2 = MakeGpioPin(0x50000704);
pub const spi_sck = MakeGpioPin(0x50000708);
pub const spi_mosi = MakeGpioPin(0x5000070C);
pub const spi_miso = MakeGpioPin(0x50000710);
pub const spi_ce = MakeGpioPin(0x50000714);
pub const bma421_sda = MakeGpioPin(0x50000718);
pub const bma421_scl = MakeGpioPin(0x5000071C);
pub const bma421_int = MakeGpioPin(0x50000720);
pub const lcd_det = MakeGpioPin(0x50000724);
pub const tp_reset = MakeGpioPin(0x50000728);
pub const p0_11 = MakeGpioPin(0x5000072C);
pub const charge_indication = MakeGpioPin(0x50000730);
pub const push_button_in = MakeGpioPin(0x50000734);
pub const lcd_backlight_low = MakeGpioPin(0x50000738);
pub const push_button_out = MakeGpioPin(0x5000073C);
pub const vibrator_out = MakeGpioPin(0x50000740);
pub const p0_17 = MakeGpioPin(0x50000744);
pub const lcd_rs = MakeGpioPin(0x50000748);
pub const power_presence_indication = MakeGpioPin(0x5000074C);
pub const traceclk = MakeGpioPin(0x50000750);
pub const n_reset = MakeGpioPin(0x50000754);
pub const lcd_backlight_mid = MakeGpioPin(0x50000758);
pub const lcd_backlight_high = MakeGpioPin(0x5000075C);
pub const power_control_3v3 = MakeGpioPin(0x50000760);
pub const lcd_cs = MakeGpioPin(0x50000764);
pub const lcd_reset = MakeGpioPin(0x50000768);
pub const status_led = MakeGpioPin(0x5000076C);
pub const tp_int = MakeGpioPin(0x50000770);
pub const ain5 = MakeGpioPin(0x50000774);
pub const hrs3300_test = MakeGpioPin(0x50000778);
pub const battery_voltage = MakeGpioPin(0x5000077C);

test "semantic-analysis" {
    testing.refAllDecls(@This());
}
