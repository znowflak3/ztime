MEMORY {
  FLASH(rx) : ORIGIN = 0x0, LENGTH = 512K
  RAM(rwx) : ORIGIN = 0x20000000, LENGTH = 64K
}

ENTRY(init)

SECTIONS {
  .isr_vector : {
    KEEP(*(.isr_vector_stack_val*))
    KEEP(*(.isr_vector*))
    . = ALIGN(4);
  } > FLASH

  .text : {
    . = ALIGN(4);
    *(.text)
    *(.text*)
    *(.rodata)
    *(.rodata*)
    . = ALIGN(4);
    __text_end = .;
  }

  .bss : {
    . = ALIGN(4);
    __bss_start = .;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    __bss_end = .;
  } > RAM

  .ARM.extab : {
    *(.ARM.extab* .gnu.linkonce.armextab.*)
  } > FLASH

  .ARM.exidx :
  {
    __exidx_start = .;
    *(.ARM.exidx* .gnu.linkonce.armexidx.*)
    __exidx_end = .;
  } > FLASH

  .data : AT ( __text_end ) {
    . = ALIGN(4);
    __data_start = .;
    __data_load = LOADADDR(.data);
    *(.data);
    *(.data*);
    __data_end = .;
  } > RAM

  __stack = ORIGIN(RAM) + LENGTH(RAM);
}