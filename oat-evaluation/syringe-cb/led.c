#include <stdio.h>
#include "lib/led.h"


extern int global_data;

void led_on() {
	global_data += 1;
	printf("%s\n", __func__);
	return;
}

void led_off() {
	printf("%s\n", __func__);
	return;
}
