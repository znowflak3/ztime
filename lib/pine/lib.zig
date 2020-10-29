pub const GpioPin = @import("gpio.zig").GpioPin;
pub const Gpio = @import("gpio.zig").Gpio;
pub const Timer = @import("timer.zig").Timer;
pub const Radio = @import("Radio.zig");
pub const Rng = @import("Rng.zig");
pub const Spim = @import("spim.zig").Spim;
pub const SpiMaster = @import("SpiMaster.zig");
//delay just for test
pub const Delay = @import("spim.zig");
pub const ST7789 = @import("st7789.zig");

comptime {
    if (!@import("builtin").is_test) _ = @import("start.zig");
}

test "semantic-analysis" {
    @import("std").testing.refAllDecls(@This());
}
