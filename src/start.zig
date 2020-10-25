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
extern var __bss_start: u8;
extern var __bss_end: u8;
extern var __stack: u8;

fn default() callconv(.C) void {
    while (true) {}
}

const stack = @intToPtr(*align(16) volatile [@sizeOf(@Frame(root.main))]u8, 0x20000000);

pub export fn init() callconv(.C) void {
    @call(.{ .stack = stack, .modifier = .never_inline }, root.main, .{});
}
