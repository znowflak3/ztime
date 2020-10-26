#ifndef ZRF_SPIM_H
#define ZRF_SPIM_H


#include "zrf_gpio.h"
#include "zrf_delay.h"

#include "stddef.h"

//spi config
#define LCD_SPIM_RESET_PIN  30
#define LCD_SPIM_SCK_PIN     4
#define LCD_SPIM_MOSI_PIN    3
#define LCD_SPIM_MISO_PIN  255
#define LCD_SPIM_SS_PIN     28
#define LCD_SPIM_DCX_PIN    29

volatile uint32_t currentBufferAddress = 0;
volatile size_t currentBufferSize = 0;

void zrf_spim_init()
{
    zrf_gpio_set_pin(LCD_SPIM_SCK_PIN);
    zrf_gpio_config_output_pin(LCD_SPIM_SCK_PIN);
    zrf_gpio_clear_pin(LCD_SPIM_MOSI_PIN);
    zrf_gpio_config_output_pin(LCD_SPIM_MOSI_PIN);
    zrf_gpio_config_output_pin(LCD_SPIM_SS_PIN);

    volatile uint32_t * PSEL_SCK = (volatile uint32_t *)0x40003508;
    *PSEL_SCK = LCD_SPIM_SCK_PIN;
    volatile uint32_t * PSEL_MOSI = (volatile uint32_t *)0x4000350C;
    *PSEL_MOSI = LCD_SPIM_MOSI_PIN;
    volatile uint32_t * FREQUENCY = (volatile uint32_t *)0x40003524;
    *FREQUENCY = 0x80000000;
    volatile uint32_t * CONFIG = (volatile uint32_t *)0x40003554;
    *CONFIG = 6;

    volatile uint32_t * EVENTS_STOPPED = (volatile uint32_t *)0x40003104;
    *EVENTS_STOPPED = 0;
    volatile uint32_t * EVENTS_ENDRX = (volatile uint32_t *)0x40003110;
    *EVENTS_ENDRX = 0;
    volatile uint32_t * EVENTS_END = (volatile uint32_t *)0x40003118;
    *EVENTS_END = 0;
    volatile uint32_t * EVENTS_ENDTX = (volatile uint32_t *)0x40003120;
    *EVENTS_ENDTX = 0;
    volatile uint32_t * EVENTS_STARTED = (volatile uint32_t *)0x4000314C;
    *EVENTS_STARTED = 0;

    volatile uint32_t * ENABLE = (volatile uint32_t *)0x40003500;
    *ENABLE = 7;
}
void zrf_spim_prepare_tx(const volatile uint32_t bufferAddress, const volatile size_t size)
{
    volatile uint32_t * TXD_PTR = (volatile uint32_t *)0x40003544;
    *TXD_PTR = bufferAddress;

    volatile uint32_t * TXD_MAXCNT = (volatile uint32_t *)0x40003548;
    *TXD_MAXCNT = size;

    volatile uint32_t * TXD_LIST = (volatile uint32_t *)0x40003550;
    *TXD_LIST = 0;

    volatile uint32_t * EVENTS_END = (volatile uint32_t *)0x40003118;
    *EVENTS_END = 0;
}

void zrf_spim_write(const uint8_t data, size_t size){

    currentBufferAddress = (uint32_t) &data;
    currentBufferSize = size;

    zrf_spim_prepare_tx(currentBufferAddress, currentBufferSize);

    volatile uint32_t * TASK_START = (volatile uint32_t *)0x40003010;
    volatile uint32_t * EVENT_ENDTX = (volatile uint32_t *)0x40003118;

    zrf_gpio_clear_pin(LCD_SPIM_SS_PIN);
    *TASK_START = 1;

    while(*EVENT_ENDTX == 0){}
    zrf_gpio_set_pin(LCD_SPIM_SS_PIN);
    *EVENT_ENDTX = 0;


}

void zrf_spim_write_bytes(uint8_t data[], uint32_t length){
	for(int i = 0; i  < length; i++){
		zrf_spim_write(data[i], 1);
	}
}

#endif
