include makefile.conf

PROJECT = test

.PHONY: clean

DEFINES=-D__STARTUP_CLEAR_BSS -D__START=main

OBJECTS += main.o
OBJECTS += startup_ARMCM4.o

TOOLCHAIN=arm-none-eabi-
CFLAGS=$(ARCH_FLAGS) $(DEFINES) $(CPU_DEFINES) $(INCLUDES) -Wall -ffunction-sections -fdata-sections -fno-builtin

LFLAGS=--specs=nosys.specs -Wl,--gc-sections -Wl,-Map=$(PROJECT).map -Tlink.ld

# Source Rules
%.o: %.S
	$(TOOLCHAIN)gcc  $(CFLAGS) -c -o $@ $<

%.o: %.c
	$(TOOLCHAIN)gcc  $(CFLAGS) -c -o $@ $<

$(PROJECT).out: $(OBJECTS)
	$(TOOLCHAIN)gcc $(LFLAGS) $^ $(CFLAGS) -o $@

$(PROJECT).bin: $(PROJECT).out
	$(TOOLCHAIN)objcopy -O binary $< $@
	
$(PROJECT).hex: $(PROJECT).out
	$(TOOLCHAIN)objcopy -I binary -O ihex $< $@

clean:
	rm -f *.bin *.map *.elf *.out *.hex output.txt
	find . -name '*.o' -delete

# Flash the program
flash:
	@echo Flashing: test.hex
	nrfjprog -f nrf52 --program test.hex --sectorerase
	nrfjprog -f nrf52 --reset

erase:
	nrfjprog -f nrf52 --eraseall
