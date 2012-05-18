#!/usr/bin/env python
# -*- coding: utf-8 -*-

import serial, os, sys

def main():
    uart = sys.argv[1]

    try:
        s = serial.Serial(uart, 115200, timeout=0.0001)
        c = s.read(16384)
        s.close()
    except:
        print "Error opening port %s" % uart
        return

    s = serial.Serial(uart, 115200)
    s.write("#C,W,18,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,1,1;");
    s.readline()
    s.write("#L,W,3,E,1,2;");
    while 1:
        print s.readline()

if __name__ == "__main__":
    main()

