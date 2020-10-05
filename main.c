#include "stdint.h"

void SystemInit(void) {
	
}
int main(void) {

	uint32_t dir = 1;
	uint32_t input= 1;
	uint32_t pull = 0;
	uint32_t drive = 0;
	uint32_t sense = 0;
	
	volatile uint32_t * PIN_CNF_17 = (volatile uint32_t *)0x50000744;
	*PIN_CNF_17 = (dir << 0UL) | (input << 1UL) | (pull << 2UL) | (drive << 8UL) | (sense << 16UL);
	
	volatile uint32_t * OUTSET = (volatile uint32_t *)0x50000508;
	volatile uint32_t * OUTCLR = (volatile uint32_t *)0x5000050C;
	*OUTSET = (1UL << 17UL);
	for (;;) {

	}
}
