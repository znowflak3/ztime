#ifndef ZRF_CLOCK_H
#define ZRF_CLOCK_H

#include "stdint.h"

void zrf_clock_start_hfclk()
{
        volatile uint32_t * TASKS_HFCLKSTART = (volatile uint32_t *) 0x40000000;
        *TASKS_HFCLKSTART = 1;
}
void zrf_clock_stop_hfclk()
{
        volatile uint32_t * TASKS_HFCLKSTOP = (volatile uint32_t *) 0x40000004;
        *TASKS_HFCLKSTOP = 1;
}
bool zrf_clock_hfclk_started()
{
        volatile uint32_t * EVENTS_HFCLKSTARTED = (volatile uint32_t *) 0x40000100;

        if(*EVENTS_HFCLKSTARTED == 1){
                return true;
        }
        else{
                return false;
        }
 
}

#endif
