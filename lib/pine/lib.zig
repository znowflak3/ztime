pub const GpioPin = @import("gpio.zig").GpioPin;
pub const Gpio = @import("gpio.zig").Gpio;
pub const Timer = @import("timer.zig").Timer;
pub const Radio = @import("Radio.zig");
pub const Rng = @import("Rng.zig");

comptime {
    _ = @import("start.zig");
}

test "semantic-analysis" {
    @import("std").testing.refAllDecls(@This());
}
