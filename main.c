#include "stdint.h"
#include "stdbool.h"

#include "zrf_gpio.h"
#include "zrf_delay.h"
#include "zrf_spi.h"

#define ST77XX_BLACK 0x0000
#define ST77XX_WHITE 0xFFFF
#define ST77XX_RED 0xF800
#define ST77XX_GREEN 0x07E0
#define ST77XX_BLUE 0x001F
#define ST77XX_CYAN 0x07FF
#define ST77XX_MAGENTA 0xF81F
#define ST77XX_YELLOW 0xFFE0
#define ST77XX_ORANGE 0xFC00

#define ST7789_CMD_SWRESET 0x01
#define ST7789_CMD_SLPOUT  0x11
#define ST7789_CMD_NORON   0x13
#define ST7789_CMD_INVON   0x21
#define ST7789_CMD_DISPON  0x29
#define ST7789_CMD_CASET   0x2A
#define ST7789_CMD_RASET   0x2B
#define ST7789_CMD_RAMWR   0x2C
#define ST7789_CMD_VSCRDEF 0x33
#define ST7789_CMD_COLMOD  0x3A
#define ST7789_CMD_MADCTL  0x36
#define ST7789_CMD_VSCSAD  0x37

void SystemInit(void) {
	
}
void zrf_st7789_hw_reset()
{
	zrf_gpio_clear_pin(LCD_SPIM_RESET_PIN);
	zrf_delay_ms(15);

	zrf_gpio_set_pin(LCD_SPIM_RESET_PIN);
	zrf_delay_ms(2);
}
void setCommandPin()
{
    zrf_gpio_clear_pin(LCD_SPIM_DCX_PIN);
}

void setDataPin()
{
    zrf_gpio_set_pin(LCD_SPIM_DCX_PIN);
}
void setWindow(uint8_t startX, uint8_t startY, uint8_t width, uint8_t height)
{

    uint8_t lcdCasetData[] = {
            (startX >> 8),
            (startX & 0xFF),
            (width >> 8),
            (width & 0xFF)
    };

    uint8_t lcdRasetData[] = {
            (startY >> 8),
            (startY & 0xFF),
            (height >> 8),
            (height & 0xFF)
    };

    setCommandPin();
    zrf_spi_write(ST7789_CMD_CASET);
    setDataPin();
    zrf_spi_write_bytes(lcdCasetData, 4);
    
    setCommandPin();
    zrf_spi_write(ST7789_CMD_RASET);
    setDataPin();
    zrf_spi_write_bytes(lcdRasetData, 4);
}
int main(void) {

	zrf_gpio_config_output_pin(17);

	//zrf_delay_ms(5000);

	//zrf_gpio_set_pin(17);

	const int16_t screenSizeX = 240;
    	const int16_t screenSizeY = 240;

	zrf_gpio_config_output_pin(LCD_SPIM_DCX_PIN);
	zrf_gpio_config_output_pin(LCD_SPIM_RESET_PIN);
	zrf_spi_init(LCD_SPIM_SS_PIN, LCD_SPIM_MISO_PIN, LCD_SPIM_MOSI_PIN, LCD_SPIM_SCK_PIN);
	zrf_delay_ms(50);
	zrf_st7789_hw_reset();
	

    	// Send the commands
    	setCommandPin();
       	zrf_spi_write(ST7789_CMD_SWRESET);
	zrf_delay_ms(150);

    	zrf_spi_write(ST7789_CMD_SLPOUT);	
	zrf_delay_ms(10);

	zrf_spi_write(ST7789_CMD_COLMOD);
    	setDataPin();
      	zrf_spi_write(0x55);
	zrf_delay_ms(10);

    	setCommandPin();
      	zrf_spi_write(ST7789_CMD_MADCTL);	
	setDataPin();
    	zrf_spi_write(0);
	
    	setWindow(0, 0, screenSizeX, screenSizeY);

    	setCommandPin();
      	zrf_spi_write(ST7789_CMD_DISPON);
	zrf_spi_write(ST7789_CMD_NORON);
	zrf_spi_write(ST7789_CMD_INVON);
	zrf_delay_ms(10);

    	//write bg black
    
    	setCommandPin();
	zrf_spi_write(ST7789_CMD_RAMWR);
	setDataPin();
	
	uint16_t bgColor = ST77XX_GREEN;
    	
	uint8_t colorData[] = {
        	(uint8_t)(bgColor >> 8),
        	(uint8_t)(bgColor & 0xFF)
    	};
    	int sbs = 5000;
	
	zrf_gpio_set_pin(17);

    	for(int i = 0; i < sbs; i++){
        	//APP_ERROR_CHECK(nrfx_spim_xfer(&lcdSpi, &xferData, 0));
		//zrf_spi_write_bytes(colorData);
    		zrf_spi_write((uint8_t)(bgColor >> 8));
		zrf_spi_write((uint8_t)(bgColor & 0xFF));
	}

	zrf_gpio_clear_pin(17);

	 	
}
