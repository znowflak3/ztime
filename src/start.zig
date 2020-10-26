const std = @import("std");
const root = @import("root");

pub export const isr_vector linksection(".isr_vector") = [_]fn () callconv(.C) void{
    init, // reset
    default, // nmi
    default, // hard fault
    default, // mem
    default, // bus fault
    default, // usage fault
    default, // reserved
    default, // reserved
    default, // reserved
    default, // reserved
    default, // svc
    default, // debug mon
    default, // reserved
    default, // pendsv
    default, // sys tick
    default, // external interupt
};

extern var __data_start: u8;
extern var __data_end: u8;
extern var __data_load: u8;
extern var __bss_start: u8;
extern var __bss_end: u8;
extern var __stack: u8;

fn default() callconv(.C) void {
    while (true) {}
}

const stack = @intToPtr(*align(16) volatile [0x10000]u8, 0x20000000);

pub export fn init() callconv(.C) void {
    const dlen = @ptrToInt(&__data_end) - @ptrToInt(&__data_start);
    const data = @ptrCast([*]u8, &__data_load)[0..dlen];
    std.mem.copy(u8, @ptrCast([*]u8, &__data_start)[0..dlen], data);
    const blen = @ptrToInt(&__bss_end) - @ptrToInt(&__bss_start);
    std.mem.set(u8, @ptrCast([*]u8, &__bss_start)[0..blen], 0);

    @call(.{ .stack = stack, .modifier = .never_inline }, root.main, .{});
}
