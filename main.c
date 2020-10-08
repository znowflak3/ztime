#include "stdint.h"
#include  "stdbool.h"

#include "zrf_gpio.h"
#include "zrf_delay.h"

void SystemInit(void) {
	
}
int main(void) {

	zrf_gpio_config_output_pin(17);

	zrf_delay_ms(5000);

	zrf_gpio_set_pin(17);
}
