#include <avr/io.h>
#include <avr/cpufunc.h>
#include <avr/sleep.h>
#include <util/delay.h>

void main(void)
{
    DDRB = 0x09;
    PORTB |= (1<<3);
    
    //set_sleep_mode(SLEEP_MODE_PWR_DOWN);
    //sleep_enable();
    
    while(1) {
        //for (uint16_t i=0; i<12; i++);
//        _delay_ms(1000);
        PORTB ^= (1<<0);
//        for (uint16_t i=0; i<6; i++);
        //PORTB |= (1<<0);
        //for (uint16_t i=0; i<24; i++);
//        PORTB &= ~(1<<3);
        _delay_loop_1(100);
    }
}

