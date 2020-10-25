const std = @import("std");

export const isr_vector linksection(".isr_vector") = [_]fn () callconv(.C) void{
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

comptime {
    asm (
        \\  .section  .isr_vector_stack,"a",%progbits
        \\  .word  __stack
    );
}

extern var __data_start: u8;
extern var __data_end: u8;
extern var __bss_start: u8;
extern var __bss_end: u8;
extern var __stack: u8;

fn default() callconv(.C) void {
    while (true) {}
}

export fn init() callconv(.C) void {
    const stack = @intToPtr(*align(16) volatile [@sizeOf(@Frame(main))]u8, 0x2000_0000);
    @call(.{ .stack = stack, .modifier = .never_inline }, main, .{});
}

pub fn main() void {
    @intToPtr(*volatile u32, 0x50000744).* = 3;
}
