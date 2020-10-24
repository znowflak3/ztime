const std = @import("std");
const testing = std.testing;

// TODO: audit
extern const __exidx_start: usize;
extern const __exidx_end: usize;
export const __copy_table_start__: usize = 0;
export const __copy_table_end__: usize = 0;
export const __zero_table_start__: usize = 0;
export const __zero_table_end__: usize = 0;
extern const __etext: usize;
extern const __data_start__: usize;
extern const __preinit_array_start: usize;
extern const __preinit_array_end: usize;
extern const __init_array_start: usize;
extern const __init_array_end: usize;
extern const __fini_array_start: usize;
extern const __fini_array_end: usize;
extern const __data_end__: usize;
extern const __bss_start__: usize;
extern const __bss_end__: usize;
extern const __end__: usize;
extern const end: usize;
extern const __HeapLimit: usize;
extern const __StackLimit: usize;
extern const __StackTop: usize;
extern const __stack: usize;

// TODO: audit
comptime {
    asm (
        \\.syntax	unified
        \\.arch	armv7e-m
        \\
        \\.section .stack
        \\.align	3
        \\.equ	Stack_Size, 0xc00
        \\.globl	__StackTop
        \\.globl	__StackLimit
        \\__StackLimit:
        \\.space	Stack_Size
        \\.size	__StackLimit, . - __StackLimit
        \\__StackTop:
        \\.size	__StackTop, . - __StackTop
        \\
        \\.section .heap
        \\.align	3
        \\.equ	Heap_Size, 0x8000
        \\.globl	__HeapBase
        \\.globl	__HeapLimit
        \\__HeapBase:
        \\.if	Heap_Size
        \\.space	Heap_Size
        \\.endif
        \\.size	__HeapBase, . - __HeapBase
        \\__HeapLimit:
        \\.size	__HeapLimit, . - __HeapLimit
        \\
        \\.section .isr_vector
        \\.align	2
        \\.globl	__isr_vector
        \\__isr_vector:
        \\.long	__StackTop            /* Top of Stack */
        \\.long	Reset_Handler         /* Reset Handler */
        \\.long	NMI_Handler           /* NMI Handler */
        \\.long	HardFault_Handler     /* Hard Fault Handler */
        \\.long	MemManage_Handler     /* MPU Fault Handler */
        \\.long	BusFault_Handler      /* Bus Fault Handler */
        \\.long	UsageFault_Handler    /* Usage Fault Handler */
        \\.long	0                     /* Reserved */
        \\.long	0                     /* Reserved */
        \\.long	0                     /* Reserved */
        \\.long	0                     /* Reserved */
        \\.long	SVC_Handler           /* SVCall Handler */
        \\.long	DebugMon_Handler      /* Debug Monitor Handler */
        \\.long	0                     /* Reserved */
        \\.long	PendSV_Handler        /* PendSV Handler */
        \\.long	SysTick_Handler       /* SysTick Handler */
        \\
        \\/* External interrupts */
        \\.long	Default_Handler
        \\
        \\.size	__isr_vector, . - __isr_vector
        \\
        \\.text
        \\.thumb
        \\.thumb_func
        \\.align	2
        \\.globl	Reset_Handler
        \\.type	Reset_Handler, %function
        \\Reset_Handler:
        \\/*  Firstly it copies data from read only memory to RAM. There are two schemes
        \\*  to copy. One can copy more than one sections. Another can only copy
        \\*  one section.  The former scheme needs more instructions and read-only
        \\*  data to implement than the latter.
        \\*  Macro __STARTUP_COPY_MULTIPLE is used to choose between two schemes.  */
        \\
        \\#ifdef __STARTUP_COPY_MULTIPLE
        \\/*  Multiple sections scheme.
        \\*
        \\*  Between symbol address __copy_table_start__ and __copy_table_end__,
        \\*  there are array of triplets, each of which specify:
        \\*    offset 0: LMA of start of a section to copy from
        \\*    offset 4: VMA of start of a section to copy to
        \\*    offset 8: size of the section to copy. Must be multiply of 4
        \\*
        \\*  All addresses must be aligned to 4 bytes boundary.
        \\*/
        \\ldr	r4, =__copy_table_start__
        \\ldr	r5, =__copy_table_end__
        \\
        \\.L_loop0:
        \\cmp	r4, r5
        \\bge	.L_loop0_done
        \\ldr	r1, [r4]
        \\ldr	r2, [r4, #4]
        \\ldr	r3, [r4, #8]
        \\
        \\.L_loop0_0:
        \\subs	r3, #4
        \\ittt	ge
        \\ldrge	r0, [r1, r3]
        \\strge	r0, [r2, r3]
        \\bge	.L_loop0_0
        \\
        \\adds	r4, #12
        \\b	.L_loop0
        \\
        \\.L_loop0_done:
        \\#else
        \\/*  Single section scheme.
        \\*
        \\*  The ranges of copy from/to are specified by following symbols
        \\*    __etext: LMA of start of the section to copy from. Usually end of text
        \\*    __data_start__: VMA of start of the section to copy to
        \\*    __data_end__: VMA of end of the section to copy to
        \\*
        \\*  All addresses must be aligned to 4 bytes boundary.
        \\*/
        \\ldr	r1, =__etext
        \\ldr	r2, =__data_start__
        \\ldr	r3, =__data_end__
        \\
        \\.L_loop1:
        \\cmp	r2, r3
        \\ittt	lt
        \\ldrlt	r0, [r1], #4
        \\strlt	r0, [r2], #4
        \\blt	.L_loop1
        \\#endif /*__STARTUP_COPY_MULTIPLE */
        \\
        \\/*  This part of work usually is done in C library startup code. Otherwise,
        \\*  define this macro to enable it in this startup.
        \\*
        \\*  There are two schemes too. One can clear multiple BSS sections. Another
        \\*  can only clear one section. The former is more size expensive than the
        \\*  latter.
        \\*
        \\*  Define macro __STARTUP_CLEAR_BSS_MULTIPLE to choose the former.
        \\*  Otherwise efine macro __STARTUP_CLEAR_BSS to choose the later.
        \\*/
        \\#ifdef __STARTUP_CLEAR_BSS_MULTIPLE
        \\/*  Multiple sections scheme.
        \\*
        \\*  Between symbol address __copy_table_start__ and __copy_table_end__,
        \\*  there are array of tuples specifying:
        \\*    offset 0: Start of a BSS section
        \\*    offset 4: Size of this BSS section. Must be multiply of 4
        \\*/
        \\ldr	r3, =__zero_table_start__
        \\ldr	r4, =__zero_table_end__
        \\
        \\.L_loop2:
        \\cmp	r3, r4
        \\bge	.L_loop2_done
        \\ldr	r1, [r3]
        \\ldr	r2, [r3, #4]
        \\movs	r0, 0
        \\
        \\.L_loop2_0:
        \\subs	r2, #4
        \\itt	ge
        \\strge	r0, [r1, r2]
        \\bge	.L_loop2_0
        \\
        \\adds	r3, #8
        \\b	.L_loop2
        \\.L_loop2_done:
        \\#elif defined (__STARTUP_CLEAR_BSS)
        \\/*  Single BSS section scheme.
        \\*
        \\*  The BSS section is specified by following symbols
        \\*    __bss_start__: start of the BSS section.
        \\*    __bss_end__: end of the BSS section.
        \\*
        \\*  Both addresses must be aligned to 4 bytes boundary.
        \\*/
        \\ldr	r1, =__bss_start__
        \\ldr	r2, =__bss_end__
        \\
        \\movs	r0, 0
        \\.L_loop3:
        \\cmp	r1, r2
        \\itt	lt
        \\strlt	r0, [r1], #4
        \\blt	.L_loop3
        \\#endif /* __STARTUP_CLEAR_BSS_MULTIPLE || __STARTUP_CLEAR_BSS */
        \\
        \\#ifndef __NO_SYSTEM_INIT
        \\bl	SystemInit
        \\#endif
        \\
        \\#ifndef __START
        \\#define __START _start
        \\#endif
        \\bl	__START
        \\
        \\.pool
        \\.size	Reset_Handler, . - Reset_Handler
        \\
        \\.align	1
        \\.thumb_func
        \\.weak	Default_Handler
        \\.type	Default_Handler, %function
        \\Default_Handler:
        \\b	.
        \\.size	Default_Handler, . - Default_Handler
        \\
        \\/*    Macro to define default handlers. Default handler
        \\*    will be weak symbol and just dead loops. They can be
        \\*    overwritten by other handlers */
        \\.macro	def_irq_handler	handler_name
        \\.weak	\handler_name
        \\.set	\handler_name, Default_Handler
        \\.endm
        \\
        \\def_irq_handler	NMI_Handler
        \\def_irq_handler	HardFault_Handler
        \\def_irq_handler	MemManage_Handler
        \\def_irq_handler	BusFault_Handler
        \\def_irq_handler	UsageFault_Handler
        \\def_irq_handler	SVC_Handler
        \\def_irq_handler	DebugMon_Handler
        \\def_irq_handler	PendSV_Handler
        \\def_irq_handler	SysTick_Handler
        \\def_irq_handler	DEF_IRQHandler
        \\
        \\.end
    );
}

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

const GpioAddress = enum {
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
        unused3: u13 = 0,
    };

    pub fn config(self: GpioAddress, cfg: GpioPinConfig) void {
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

export fn SystemInit() void {}

export fn __START() void {}
