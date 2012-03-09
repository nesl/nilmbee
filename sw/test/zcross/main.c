#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/cpufunc.h>
#include <avr/sleep.h>
#include <util/delay.h>

void tx_word(uint16_t d);

volatile uint8_t flag;

void main(void)
{
    uint16_t x = 100;
//    flag = 1;

    DDRB = 0x01;
    PORTB &= ~(1<<0);
    PORTB |= (1<<0);
    
    PCMSK = (1<<1);
    PCICR = (1<<0);
    sei();
    
    while(1) {
/*        _delay_loop_1(10);
        if ((ACSR & (1<<ACO)) == 0) {
            PORTB &= ~(1<<0);
            _delay_loop_1(10);
            PORTB |= (1<<0);
            _delay_loop_1(100);
        }
*/
        if (flag) {
            cli();
            tx_word(x++);
            sei();
            flag = 0;
        }
//        _delay_ms(500);
    }
}

ISR(PCINT0_vect)
{
    static uint8_t i = 0;
    if (++i == 120) {
        flag = 1;
        i = 0;
    }
    return;
}

EMPTY_INTERRUPT(BADISR_vect);

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
    DATAL; DELAY(100); DATAH; DELAY(100); DATAL;
    for (i=0; i<16; i++) 
        DELAY(195);
    uint8_t p = 0;
    uint8_t b = 1;
    for (i=0; i<17; i++) {
        DATALOGIC(b);DELAY(201); DELAY(201);
        DATALOGIC(b^1);DELAY(201); DELAY(200);
        b = (d & 1);
        p ^= b;
        d >>=1;
    }
    DATALOGIC(p);DELAY(201); DELAY(201);
    DATALOGIC(p^1);DELAY(201); DELAY(200);
    DATALOGIC(0);
    return;
}

