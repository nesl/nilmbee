#include "rf.h"

#define DELAY(x) _delay_loop_1(x)
#define DATALOGIC(x) PORTB = (PORTB & ~(1<<0)) | (x)
#define DATAL PORTB = (PORTB & ~(1<<0))
#define DATAH PORTB = (PORTB | (1<<0))

void tx_word(Message msg)
{
    uint16_t d = msg.word;
    //msg.byte2 += 0x10;
    DATAH; 
    for (uint8_t i=0; i<8; i++) 
        DELAY(0);
    DATAL; DELAY(100); DATAH; DELAY(100); DATAL;
    for (uint8_t i=0; i<16; i++) 
        DELAY(195);
    //for (uint8_t i=0; i<16; i++) {
    //    DATAH;DELAY(100);DATAL;DELAY(100);
    //}
    //DELAY(101);DELAY(101);DATAH;DELAY(98);
    uint8_t p = 0;
    uint8_t b = 1;
    for (uint8_t i=0; i<17; i++) {
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

