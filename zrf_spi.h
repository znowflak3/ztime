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

void zrf_spi_init(uint32_t ss_pin, uint32_t miso_pin, uint32_t mosi_pin, uint32_t sck_pin)
{
	zrf_gpio_config_output_pin(ss_pin);
	zrf_gpio_set_pin(ss_pin);
	zrf_gpio_config_output_pin(mosi_pin);
	zrf_gpio_clear_pin(mosi_pin);
	zrf_gpio_config_output_pin(sck_pin);
	zrf_gpio_set_pin(sck_pin);
}
void zrf_spi_read(){
        for(uint32_t i = 0 ; i < 8; i++)
        {
                zrf_gpio_set_pin(LCD_SPIM_SCK_PIN);
                zrf_delay_ms(5);

                zrf_gpio_clear_pin(LCD_SPIM_SCK_PIN);
                zrf_delay_ms(5);

        }
}

void zrf_spi_write(uint8_t data){
	zrf_gpio_clear_pin(LCD_SPIM_SS_PIN);
	for(int i = 0; i < 8; i++)
	{
		
		zrf_gpio_clear_pin(LCD_SPIM_SCK_PIN);	
		if(data & (1UL << (7 - i))){
			zrf_gpio_set_pin(LCD_SPIM_MOSI_PIN);
		}
		else{
			zrf_gpio_clear_pin(LCD_SPIM_MOSI_PIN);
		}
		zrf_gpio_clear_pin(LCD_SPIM_SCK_PIN);
		zrf_delay_ms(1);
		zrf_gpio_set_pin(LCD_SPIM_SCK_PIN);
		zrf_delay_ms(1);

		
	}
	zrf_gpio_clear_pin(LCD_SPIM_MOSI_PIN);
	zrf_gpio_set_pin(LCD_SPIM_SCK_PIN);
	zrf_gpio_set_pin(LCD_SPIM_SS_PIN);

}

void zrf_spi_write_bytes(uint8_t data[], uint32_t length){
	for(int i = 0; i  < length; i++){
		zrf_spi_write(data[i]);		
	}
}

#endif
