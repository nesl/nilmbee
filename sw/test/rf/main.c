#include <avr/io.h>
#include <avr/cpufunc.h>
#include <avr/sleep.h>
#include <util/delay.h>

void tx_word(uint16_t d);
uint16_t x = 0;

void main(void)
{

    DDRB = 0x09;
    PORTB |= (1<<3);
    
    //set_sleep_mode(SLEEP_MODE_PWR_DOWN);
    //sleep_enable();
    
    while(1) {
        tx_word(x++);
//        tx_word(x++);
        for (uint8_t i=0; i<64; i++) {
            _delay_loop_1(0);
        }
//        _delay_ms(400);
    }
}

#define DELAY(x) _delay_loop_1(x)
#define DATALOGIC(x) PORTB = (PORTB & ~(1<<0)) | (x)
#define DATAL PORTB = (PORTB & ~(1<<0))
#define DATAH PORTB = (PORTB | (1<<0))

void tx_word(uint16_t d)
{
    uint8_t i;

    DATAH; 
    for (i=0; i<8; i++) 
        DELAY(0);
    DATAL; DELAY(100); DATAH; DELAY(180); DATAL;
    for (i=0; i<16; i++) 
        DELAY(190);
    uint8_t p = 0;
    uint8_t b = 1;
    for (i=0; i<17; i++) {
        if (b) {
            DATALOGIC(1);DELAY(151); DELAY(151);
            DATALOGIC(0);DELAY(251); DELAY(250);
        } else {
            DATALOGIC(0);DELAY(251); DELAY(251);
            DATALOGIC(1);DELAY(151); DELAY(150);
        }
        b = (d & 1);
        p ^= b;
        d >>=1;
    }
    if (p) {
        DATALOGIC(1);DELAY(151); DELAY(151);
        DATALOGIC(0);DELAY(251); DELAY(250);
    } else {
        DATALOGIC(0);DELAY(251); DELAY(251);
        DATALOGIC(1);DELAY(151); DELAY(150);
    }
    DATALOGIC(0);
    return;
}

