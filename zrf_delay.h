#ifndef ZRF_DELAY_H
#define ZRF_DELAY_H

#include "stdint.h"
#include "stdbool.h"

void zrf_delay(uint32_t ticks)
{

        volatile uint32_t * MODE = (volatile uint32_t *) 0x40008540;
        *MODE = 0;
        volatile uint32_t * BITMODE  = (volatile uint32_t *) 0x40008508;
        *BITMODE = 3;
        volatile uint32_t * PRESCALER = (volatile uint32_t *) 0x40008510;
        *PRESCALER = 0;

	//uinti32_t ms_in_ticks = 1000 / 0.0625;
        volatile uint32_t * CC_0 = (volatile uint32_t *) 0x40008540;
        *CC_0 = ticks;


        volatile uint32_t * EVENTS_COMPARE_0 = (volatile uint32_t *) 0x40008140;
        *EVENTS_COMPARE_0 = 0;

        volatile uint32_t * TASKS_CLEAR= (volatile uint32_t *) 0x4000800C;
        *TASKS_CLEAR = 1;

        volatile uint32_t * TASKS_START = (volatile uint32_t *) 0x40008000;
        *TASKS_START = 1;

        while(*EVENTS_COMPARE_0 == 0){}

}
void zrf_delay_ms(uint32_t milliSeconds)
{
        
        volatile uint32_t * MODE = (volatile uint32_t *) 0x40008540;
        *MODE = 0;
        volatile uint32_t * BITMODE  = (volatile uint32_t *) 0x40008508;
        *BITMODE = 3;
        volatile uint32_t * PRESCALER = (volatile uint32_t *) 0x40008510;
        *PRESCALER = 0;

	uint32_t ms_in_ticks = 1000 / 0.0625;
        volatile uint32_t * CC_0 = (volatile uint32_t *) 0x40008540;
        *CC_0 = milliSeconds * ms_in_ticks;


        volatile uint32_t * EVENTS_COMPARE_0 = (volatile uint32_t *) 0x40008140;
        *EVENTS_COMPARE_0 = 0;

        volatile uint32_t * TASKS_CLEAR= (volatile uint32_t *) 0x4000800C;
        *TASKS_CLEAR = 1;

        volatile uint32_t * TASKS_START = (volatile uint32_t *) 0x40008000;
        *TASKS_START = 1;

        while(*EVENTS_COMPARE_0 == 0){}
}

#endif
