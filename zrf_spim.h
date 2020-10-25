#ifndef ZRF_SPI_H
#define ZRF_SPI_H


#include "zrf_gpio.h"
#include "zrf_delay.h"

//spi config
#define LCD_SPIM_RESET_PIN  30
#define LCD_SPIM_SCK_PIN     4
#define LCD_SPIM_MOSI_PIN    3
#define LCD_SPIM_MISO_PIN  255
#define LCD_SPIM_SS_PIN     28
#define LCD_SPIM_DCX_PIN    29

void zrf_spim_init()
{
    volatile uint32_t * PSEL_SCK = 0x40003508;
    volatile uint32_t * PSEL_MOSI = 0x4000350C;
    volatile uint32_t * FREQUENCY = 0x40003524;
    volatile uint32_t * TXD_PTR = 0x40003544;
    volatile uint32_t * TXD_MAXCNT = 0x40003548;
    volatile uint32_t * TXT_AMOUNT = 0x4000354C;
    volatile uint32_t * TXT_LIST = 0x40003550;
}

void zrf_spi_write(uint8_t data){

}

void zrf_spi_write_bytes(uint8_t data[], uint32_t length){
	for(int i = 0; i  < length; i++){
		zrf_spi_write(data[i]);
	}
}

#endif
