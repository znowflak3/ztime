const std = @import("std");
const Watchdog = @This();

const base = 0x40010000;

pub fn start(wd: Watchdog) void {
    const address = @intToPtr(*volatile u32, base);
    address.* = 1;
}

pub fn readEvent(wd: Watchdog) u32 {
    const offset = 0x100;
    const address = @intToPtr(*volatile u32, base + offset);
    return address.*;
}

pub fn setInterrupt(wd: Watchdog) void {
    const offset = 0x304;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 1;
}

pub fn clearInterrupt(wd: Watchdog) void {
    const offset = 0x308;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 1;
}

pub const WatchdogRunStatus = enum {
    not_running,
    running,
};

pub fn readRunStatus(wd: Watchdog) WatchdogRunStatus {
    const offset = 0x308;
    const address = @intToPtr(*volatile u32, base + offset);
    return @intToEnum(WatchdogRunStatus, @truncate(u1, address.*));
}

pub const WatchdogRequestStatus = packed struct {
    rr_0: RequestStatus,
    rr_1: RequestStatus,
    rr_2: RequestStatus,
    rr_3: RequestStatus,
    rr_4: RequestStatus,
    rr_5: RequestStatus,
    rr_6: RequestStatus,
    rr_7: RequestStatus,

    pub const RequestStatus = enum(u1) {
        disabled_or_requested,
        enabled_and_unrequested,
    };
};

pub fn readRequestStatus(wd: Watchdog) WatchdogRequestStatus {
    const offset = 0x404;
    const address = @intToPtr(*volatile u32, base + offset);
    return @bitCast(WatchdogRequestStatus, @truncate(u8, address.*));
}

pub fn setCounterReloadValue(wd: Watchdog, value: u32) void {
    const offset = 0x504;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = value;
}

pub fn readCounterReloadValue(wd: Watchdog) u32 {
    const offset = 0x504;
    const address = @intToPtr(*volatile u32, base + offset);
    return address.*;
}

pub const WatchdogReloadRequest = packed struct {
    rr_0: ReloadEnable,
    rr_1: ReloadEnable,
    rr_2: ReloadEnable,
    rr_3: ReloadEnable,
    rr_4: ReloadEnable,
    rr_5: ReloadEnable,
    rr_6: ReloadEnable,
    rr_7: ReloadEnable,

    pub const ReloadEnable = enum(u1) { disabled, enabled };
};

pub fn setReloadRequestCfg(wd: Watchdog, cfg: WatchdogReloadRequest) void {
    const offset = 0x508;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = @bitCast(u8, cfg);
}

pub fn readReloadRequestCfg(wd: Watchdog) WatchdogReloadRequest {
    const offset = 0x508;
    const address = @intToPtr(*volatile u32, base + offset);
    return @bitCast(WatchdogReloadRequest, @truncate(u8, address.*));
}

pub const Config = packed struct {
    sleep: ConfigState,
    _unused: u2 = 0,
    halt: ConfigState,

    pub const ConfigState = enum(u1) { pause, run };
};

pub fn setConfig(wd: Watchdog, cfg: Config) void {
    const offset = 0x50c;
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = @bitCast(u4, cfg);
}

pub fn readConfig(wd: Watchdog) Config {
    const offset = 0x50c;
    const address = @intToPtr(*volatile u32, base + offset);
    return @bitCast(Config, @truncate(u4, address.*));
}

pub const WatchdogRequest = enum(u32) {
    rr_0 = 0x600,
    rr_1 = 0x604,
    rr_2 = 0x608,
    rr_3 = 0x60c,
    rr_4 = 0x610,
    rr_5 = 0x614,
    rr_6 = 0x618,
    rr_7 = 0x61c,
};

pub fn reload(wd: Watchdog, request: WatchdogRequest) void {
    const offset = @enumToInt(request);
    const address = @intToPtr(*volatile u32, base + offset);
    address.* = 0x6e524635;
}

test "semantic-analysis" {
    std.testing.refAllDecls(@This());
}
