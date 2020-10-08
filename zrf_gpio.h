#ifndef ZRF_GPIO_H
#define ZRF_GPIO_H

#include "stdint.h"

uint32_t zrf_gpio_get_pin_adress(uint32_t pin_number){
	uint32_t pin_configs[] = { 0x50000700, 0x50000704, 0x50000708, 0x5000070C,
				   0x50000710, 0x50000714, 0x50000718, 0x5000071C,
				   0x50000720, 0x50000724, 0x50000728, 0x5000072C,
		                   0x50000730, 0x50000734, 0x50000738, 0x5000073C,
				   0x50000740, 0x50000744, 0x50000748, 0x5000074C,
				   0x50000750, 0x50000754, 0x50000758, 0x5000075C,
				   0x50000760, 0x50000764, 0x50000768, 0x5000076C,
				   0x50000770, 0x50000774, 0x50000778, 0x5000077C };

	if(pin_number >= 0 && pin_number < 32){
		return pin_configs[pin_number];
	}

	return -1;
}
void zrf_gpio_config_output_pin(uint32_t pin_number){
        uint32_t dir = 1;
        uint32_t input= 1;
        uint32_t pull = 0;
        uint32_t drive = 0;
        uint32_t sense = 0;

        volatile uint32_t * PIN_CNF_17 = (volatile uint32_t *) zrf_gpio_get_pin_adress(pin_number);
        *PIN_CNF_17 = (dir << 0UL) | (input << 1UL) | (pull << 2UL) | (drive << 8UL) | (sense << 16UL);
}
void zrf_gpio_set_pin(uint32_t pin_number){
        volatile uint32_t * OUTSET = (volatile uint32_t *) 0x50000508;
        *OUTSET = (1UL << pin_number);
}
void zrf_gpio_clear_pin(uint32_t pin_number){
        volatile uint32_t * OUTCLR = (volatile uint32_t *) 0x5000050C;
        *OUTCLR = (1UL << pin_number);
}

#endif
