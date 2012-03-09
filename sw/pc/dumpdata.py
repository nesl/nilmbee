#!/usr/bin/env python
# -*- coding: utf-8 -*-

import serial
import sys

if len(sys.argv) < 2:
    print "Usage: ./dumpdata.py serial_port"
    exit()

ser = serial.Serial(sys.argv[1], 115200)

while 1:
    d = 0
    x = ord(ser.read())
    if x & 0xC0 != 0: 
        print "Junk: %x" % x
        continue
    d += ((x & 0x3F) << 10);
    
    x = ord(ser.read())
    if x & 0xC0 != 0x40:
        print "Junk: %x" % x
        continue
    d += ((x & 0x3F) << 4);

    x = ord(ser.read())
    if x & 0xC0 != 0x80:
        print "Junk: %x" % x
        continue
    d += (x & 0x0F);

    s = "RECV %x(%d) (id=%d, gp=%d, idx=%d, seq=%d, active=%d)"
    s = s % (d, d, (d&0xFC00)>>10, (d&0x0300)>>8, (d&0xE)>>1, (d&0xF0)>>4, d&0x1)
    
    print s
    
