#!/usr/bin/env python
# -*- coding: utf-8 -*-

import serial
import sys
import time, datetime

if len(sys.argv) < 4:
    print "Usage: ./simuevent.py serial_port id is_active"
    exit()

ser = serial.Serial(sys.argv[1], 115200)

id = int(sys.argv[2])
is_active = int(sys.argv[3])

cmd = (id << 2) + is_active

ser.write(chr(cmd))
ser.flush()
ser.close()

