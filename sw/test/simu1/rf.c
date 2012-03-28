#include "rf.h"

#define DELAY(x) _delay_loop_1(x)
#define DATALOGIC(x) PORTB = (PORTB & ~(1<<0)) | (x)
#define DATAL PORTB = (PORTB & ~(1<<0))
#define DATAH PORTB = (PORTB | (1<<0))

void tx_word(Message msg)
{
    uint8_t i;
    uint16_t d = msg.word;

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

