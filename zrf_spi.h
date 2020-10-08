#ifndef ZRF_SPI_H
#define ZRF_SPI_H


#include "zrf_gpio.h"
#include "zrf_delay.h"

void zrf_spi_init()
{

}
void zrf_spi_write(char data){
	
	for(uint32_t i = 0 ; i < 8; i++)
	{
		zrf_gpio_set_pin(sclk_pin);
		if(data & (1UL << i)){
			zrf_gpio_set_pin(mosi_pin);
		}
		else{
			zrf_gpio_clear_pin(mosi_pin);
		}

		zrf_delay_ms(1);
		zrf_gpio_clear_pin(sclk_pin);

		zrf_delay_ms(1);
		
	}

	zrf_spi_read();
}
void zrf_spi_read(){
	for(uint32_t i = 0 ; i < 8; i++)
        {
                zrf_gpio_set_pin(sclk_pin);
                zrf_delay_ms(1);
		
                zrf_gpio_clear_pin(sclk_pin);
                zrf_delay_ms(1);
                
        }
}

#endif
