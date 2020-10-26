const build_options = @import("build_options");

pub const Gpio = packed struct {
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

    pub fn set(self: Gpio) void {
        if (build_options.use_pine_gpio) {
            gpio_set_address.* = @bitCast(u32, self);
        } else {
            var dev = self;
            // TODO: remap pine spi to dev board spi
            gpio_set_address.* = @bitCast(u32, self);
        }
    }

    pub fn clear(self: Gpio) void {
        if (build_options.use_pine_gpio) {
            gpio_clear_address.* = @bitCast(u32, self);
        } else {
            var dev = self;
            // TODO: remap pine spi to dev board spi
            gpio_clear_address.* = @bitCast(u32, dev);
        }
    }
};

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

    pub fn config(self: GpioPin, cfg: PinConfig) void {
        const address = @intToPtr(*volatile u32, @enumToInt(self));
        address.* = @bitCast(u32, cfg);
    }
};
