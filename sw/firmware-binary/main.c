#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <util/delay.h>
#include "rf.h"

#include "nodeid.h"

Message msg;
uint8_t delay_count = 0;
uint8_t rand_counter;
uint8_t next_delay;

#define DEBOUNCE_1 8
#define DEBOUNCE_2 8

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
    PCMSK = (1<<1);
    PCICR = (1<<0);
    sei();
}

void inline adc_start(void)
{
//    ADCSRA |= (1<<ADEN);
    ADCSRA = (4<<ADPS0) | (1<<ADEN) | (1<<ADSC) | (1<<ADIF);
//    set_sleep_mode(SLEEP_MODE_ADC);
//    sleep_mode();
}

int main(void)
{
    //uint8_t last_is_zero = 1;

    uint8_t i, dirty;
    uint8_t adcv, adcmax, adcmin;
    uint8_t score = 16;

    pin_init();
    adc_init();
    sei();
    
    // emu: msg.id = NODE_ID;
    msg.byte1 = (NODE_ID<<2);
    msg.byte2 = 0;
    
    while(1) {
        for (i=0, adcmax=0, adcmin=255; i<100; i++) {
            adc_start();
            while (!(ADCSRA & (1<<ADIF)));
            adcv = ADCL;
            if (adcv > adcmax) adcmax = adcv;
            if (adcv < adcmin) adcmin = adcv;
        }
        rand_counter += adcv ;
        
        adcmax = adcmax - adcmin;
        adcmin = 12;
        i = (msg.byte2 & 1);
        if (i) adcmin-=2;
        
        score +=1;
        if (adcmax<adcmin) score -=2;
        if (score == 16-DEBOUNCE_1-1) score = 16-DEBOUNCE_1;
        if (score == 16+DEBOUNCE_1+1) score = 16+DEBOUNCE_1;

        dirty = 0;
        if (i && score <= 16-DEBOUNCE_1) {
            dirty = 1;
            // emu: msg.is_active = 0;
            // emu: msg.delay_pos = 0;
            msg.byte2 = (msg.byte2 & 0xF0);
        } else if (!i && score >= 16+DEBOUNCE_1) {
            dirty = 1;
            // emu: msg.is_active = 1;
            // emu: msg.delay_pos = 0;
            msg.byte2 = (msg.byte2 & 0xF0) | 0x1;
        }
        if (dirty) {
            // emu: msg.delay_grp = 0;
            msg.byte1 &= ~0x3;
            
            cli();
            tx_word(msg);
            msg.byte2 += 0x10;
            sei();
            
            i = (rand_counter & 0x0E);
            next_delay = 0xC0 | (i << 2);
            msg.byte1 |= 0x3;
            msg.byte2 |= i;
            delay_count = 254;
        }
        //tx_word(adcmax - adcmin);
    }
}

ISR(PCINT0_vect)
{
    uint8_t i;
    if ((PINB & (1<<1)) && delay_count) {
        delay_count -= 2;
        if (delay_count == next_delay) {
            tx_word(msg);
            msg.byte2 += 0x10;
            next_delay = (delay_count & 0xC0) - 0x40; 
            i = (rand_counter & 0x0E);
            next_delay |= (i << 2);
            msg.byte1 = (msg.byte1 & 0xFC) | (next_delay >> 6);
            msg.byte2 = (msg.byte2 & 0xF1) | i;
            if (!next_delay) {
                next_delay = 0x08;
                msg.byte2 += 0x02;
            }
            
        }
    }
}

EMPTY_INTERRUPT(BADISR_vect);

