#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Collect power data from WattsUp device and send them with JSON format
# Set each of device object as a thread, improve performance efficiency
# Each device has multiple channels to monitor (e.g., power, current, voltage, ...)
#
# Author: Han Zhao <zdhzh@ucla.edu>
# 

import serial, time, urllib, urllib2, json, os, sys
from threading import Thread

class WattsUpDevice(Thread):
    '''Collect power data from WattsUp device. '''
    
    def __init__(self, reportingURL, uart, wattsup_id, period):
        self._url = reportingURL
        self._wattsup_id = wattsup_id
        self._uart = uart
        self._init = False
        
        Thread.__init__(self)
        try:
            s = serial.Serial(uart, 115200, timeout=0.0001)
            c = s.read(16384)
            s.close()
        except:
            print "Error opening port %s" % uart
            return
        
        s = serial.Serial(uart, 115200, timeout=5)
        #s.write("#C,W,18,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,0,1,1;");
        #s.readline()
        #s.write("#L,W,3,E,1,%d;" % period);
        
        self._serial = s
        print "Begin logging on %s (%d)" % (uart, wattsup_id)
        self._init = True
        self.stop = False
    
    def __del__(self):
        try:
            self._serial.close()
        except:
            pass
       
    def parseLine(self, l):
        l = l.strip()
        if not l:
            return 0
        if not (l[0]=='#' and l[-1]==';'):
            return 0
        l = l[1:-1]
        data = l.split(',')
        if len(data) != 21:
            return 0
        return l
        
    def reportData(self, l):
        body = {}
        body['id'] = self._wattsup_id
        body['data'] = l
        req = urllib2.Request(self._url, urllib.urlencode(body))
        try:
            r = json.loads(urllib2.urlopen(req).read())
        except:
            print "Cannot report (%d): %s" % (self._wattsup_id, l)
            return
        
        if r['r'] != 0:
            print "Report error (%d): %s" % (self._wattsup_id, r['msg'])
        
    def run(self):
        while self._init and not self.stop:
            l = ''
            try:
                l = self._serial.readline()
            except OSError:
                pass
            
            if not l:
                self._init = False
                self._serial.close()
                self._serial = serial.Serial(self._uart, 115200, timeout=5)
                self._init = True
                print "Serial error, restarted %s." % self._uart
            
            l = self.parseLine(l)
            if not l:
                continue
            self.reportData(l)

def configParam(configFileName):
    configDir = os.path.dirname(sys.argv[0])
    if not configDir:
        configDir = os.getcwd()
    argList = []
    try:
        configFile = open(configDir + "/" + configFileName)
        for line in configFile:
            if '#' in line:
                line, comment = line.split('#', 1)
            line = line.strip()
            if line:
                element = line.split()
                if len(element) >= 2:
                    argList.append(element)
                else:
                    print "Incorrect number of arguments in configuration file %s" %(configFileName)
                    sys.exit(1)     
    except IOError as (errno, strerror):
        print "I/O error({0}): {1}".format(errno, strerror)
        raise
    except:
        print "Unexpected error:", sys.exc_info()[0]
        raise
    else:
        configFile.close()
        return argList

def main():
    argList = configParam("wattsup_http.conf")
    reportingURL = "http://172.17.5.53/wattsup_log/log.php?token=nilmbee"
    for arg in argList:
        if 'ServerAddress' in arg:
            reportingURL = arg[1]
            argList.remove(arg)
    devices = []
    try:
        for arg in argList:
            device = WattsUpDevice(reportingURL, arg[0], int(arg[1]), int(arg[2]))
            #device.daemon = True
            device.start()
            devices.append(device)
            time.sleep(0.2)
        while True:
            time.sleep(1000)
    except (KeyboardInterrupt, SystemExit):
        print '\nReceived keyboard interrupt, quitting all child threads!\n'
    for device in devices:
        device.stop = True
        device.join()

if __name__ == "__main__":
    main()

