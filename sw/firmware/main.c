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

#define DEBOUNCE_1 7
#define DEBOUNCE_2 15

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

    uint8_t i, dirty, active = 0;
    uint8_t adcv, adcmax, adcmin, lastadc = 0;
    uint8_t score = 16, score2 = 16;

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
        
        dirty = 0;
        adcmax = adcmax - adcmin;
        adcmin = 12;
        //i = (msg.byte2 & 1);
        if (active) adcmin-=2;
        
        score +=1;
        if (adcmax<adcmin) score -=2;
        if (score == 16-DEBOUNCE_1-1) score = 16-DEBOUNCE_1;
        if (score == 16+DEBOUNCE_1+1) score = 16+DEBOUNCE_1;
        
        if (adcmax > lastadc && adcmax-lastadc > 10) {
            score2 += 1;
        } else if (adcmax <= lastadc && lastadc-adcmax > 10) {
            score2 -= 1;
        } else {
            score2 = 16;
        }

        if (active && score <= 16-DEBOUNCE_1) {
            dirty = 1;
            msg.byte1 &= ~0x80;
            // emu: msg.is_active = 0;
            // emu: msg.delay_pos = 0;
            active = 0;
            msg.byte2 &= 0xFE;
        } else if (!active && score >= 16+DEBOUNCE_1) {
            dirty = 1;
            msg.byte1 &= ~0x80;
            // emu: msg.is_active = 1;
            // emu: msg.delay_pos = 0;
            active = 1;
            msg.byte2 |= 0x1;
        } else if (score2 == 16-DEBOUNCE_2-1) {
            msg.byte1 |= 0x80;
            msg.byte2 &= 0xFE;
            dirty = 1;
        } else if (score2 == 16+DEBOUNCE_2+1) {
            msg.byte1 |= 0x80;
            msg.byte2 |= 0x1;
            dirty = 1;
        }
        if (dirty) {
            lastadc = adcmax;
            score2 = 16;
            // emu: msg.delay_grp = 0;
            msg.byte1 &= ~0x3;
            msg.byte2 = (msg.byte2 & 0xF1);
            
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

