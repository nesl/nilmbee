#!/usr/bin/env python
# -*- coding: utf-8 -*-

import serial
import sys
import time, datetime

if len(sys.argv) < 2:
    print "Usage: ./dumpdata.py serial_port"
    exit()

ser = serial.Serial(sys.argv[1], 115200, timeout=0.2)

c = ser.read(16384)
ser.close()

ser = serial.Serial(sys.argv[1], 115200)
olddata = 0
packetlost = 0
packetrecv = 0
begintime = 0

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

    if olddata: 
        packetlost += d-olddata-1
    else:
        begintime = time.time()
    olddata = d
    packetrecv += 1

    s = "%f(%s) %x(%d) (id=%d, gp=%d, idx=%d, seq=%d, active=%d)"
    timestamp = time.time();
    hr_time = str(datetime.datetime.fromtimestamp(timestamp))
    s = s % (timestamp, hr_time, d, d, (d&0xFC00)>>10, (d&0x0300)>>8, (d&0xE)>>1, (d&0xF0)>>4, d&0x1)
    
    print s
    #elaspedtime = time.time()-begintime
    #print "%d %d/%d" % (d, packetlost, (packetlost+packetrecv))
    #if (packetlost+packetrecv) % 100 == 0:
    #    print "recv 100 pkts in %f sec, %f pkts/sec, lost rate: %f%%" % (elaspedtime, 100.0/elaspedtime, (packetlost*100.0)/(packetlost+packetrecv))
        
    
