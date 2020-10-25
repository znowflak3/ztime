MEMORY {
  FLASH(rx) : ORIGIN = 0x0, LENGTH = 128K
  RAM(rwx) : ORIGIN = 0x20000000, LENGTH = 8K
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
    _end_text = .;
  }

  .bss : {
    . = ALIGN(4);
    _start_bss = .;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _end_bss = .;
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

  .data : AT ( _end_text ) {
    . = ALIGN(4);
    _start_data = .;
    *(.data);
    *(.data*);
    _end_data = .;
  } > RAM

  __stack = ORIGIN(RAM) + LENGTH(RAM);
}
