#include "stdint.h"
#include "stdbool.h"

#include "zrf_gpio.h"
#include "zrf_delay.h"

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

//spi config
#define LCD_SPIM_RESET_PIN  30
#define LCD_SPIM_SCK_PIN     4
#define LCD_SPIM_MOSI_PIN    3
#define LCD_SPIM_MISO_PIN  255
#define LCD_SPIM_SS_PIN     28
#define LCD_SPIM_DCX_PIN    29


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
    nrf_gpio_pin_clear(LCD_SPIM_DCX_PIN);
}

void setDataPin()
{
    nrf_gpio_pin_set(LCD_SPIM_DCX_PIN);
}
int main(void) {

	zrf_gpio_config_output_pin(17);

	zrf_delay_ms(5000);

	zrf_gpio_set_pin(17);

	//const int16_t screenSizeX = 240;
    	//const int16_t screenSizeY = 240;

	//zrf_gpio_config_output_pin(LCD_SPIM_DCX_PIN);
	//zrf_gpio_config_output_pin(LCD_SPIM_RESET_PIN);
	
	//zrf_st7789_hw_reset();


}
