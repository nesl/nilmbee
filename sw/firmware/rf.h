#ifndef _RF_H_
#define _RF_H_
#include <avr/io.h>
#include <util/delay.h>

    
typedef union Message {
    struct {
    // byte2: 
        uint8_t is_active : 1;
        uint8_t delay_pos: 3;
        uint8_t seq : 4;
    // byte1: 
        uint8_t delay_grp: 2;
        uint8_t id : 6;
    };
    struct {
        uint8_t byte2;
        uint8_t byte1;
    };
    uint16_t word;
} Message;

void tx_word(Message msg);

#endif

