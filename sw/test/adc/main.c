#include <avr/io.h>
#include <avr/cpufunc.h>
#include <avr/sleep.h>
#include <util/delay.h>
#include <avr/interrupt.h>

void tx_word(uint16_t d);
uint16_t adcv = 0;

void inline adc_init(void)
{
    //PRR = 0;
    ADMUX = 2;
    //ADCSRA = (4<<ADPS0) | (1<<ADIE) | (1<<ADEN);
    ADCSRA = (4<<ADPS0) | (1<<ADEN);
    DIDR0 = 0x4;
}

void inline pin_init(void)
{
    DDRB = 0x09;
    PORTB |= (1<<3);
//    PCMSK = (1<<1);
//    PCICR = (1<<0);
//    sei();
}

void inline adc_start(void)
{
//    ADCSRA |= (1<<ADEN);
    ADCSRA = (4<<ADPS0) | (1<<ADEN) | (1<<ADSC) | (1<<ADIF);
//    set_sleep_mode(SLEEP_MODE_ADC);
//    sleep_mode();
}

void main(void)
{
    pin_init();
    adc_init();
    
    while(1) {
        adc_start();
        while (!(ADCSRA & (1<<ADIF)));
        adcv = ADCL;
        tx_word(adcv);
        _delay_ms(500);
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

