# -*- coding: utf-8 -*-
#
# Collect power data from WattsUp device and send them with JSON format
# Set each of device object as a thread, improve performance efficiency
# Each device has multiple channels to monitor (e.g., power, current, voltage, ...)
#
# Author: Han Zhao <zdhzh@ucla.edu>
# 

import serial, time, urllib2, json, os, sys
from threading import Thread


class WattsUpDevice(Thread):
    '''Collect power data from WattsUp device. '''
    reportingCreateURL = "http://172.17.5.197/dashboard/reporting/create"

    def __init__(self, reportingCreateURL, serialPort, location, period, resourceList):
        Thread.__init__(self)
        self._responseURLdict = {}
        self._initFlag = True
        self._readingSeq = 0
        
        self._location = location
        self._reportingCreateURL = reportingCreateURL
        self._period = period
        self._resourceList = resourceList
        
        self._samplingFrequency = "%.3f" %(1.0/self._period)   # Hz
        
        self._serial = serial.Serial(serialPort, 115200, timeout = 1)
        self._serial.write('#C,W,18,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1;')
        self._serial.write('#L,W,3,E,1,1;')
        
    def startSampling(self, channel):
        if 'power' in channel:
            field = 3
        elif 'voltage' in channel:
            field = 4
        elif 'current' in channel:
            field = 5
        elif 'PF' in channel:
            field = 16
        elif 'Hz' in channel:
            field = 19
        elif 'VA' in channel:
            field = 20
        
        if self._line.startswith('#d') and len(self._line) >= 30:
            try:
                self._reading = int(self._line.strip(';\r\n').split(',')[field])
            except:
                self._reading = None
            self._readingTime = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        else:
            self._reading = self._readingTime = None

    def postJson(self, url, data):
        req = urllib2.Request(url, data, {'Content-Type':'application/json'})
        f = urllib2.urlopen(req)
        response = f.read()
        f.close()
        return response

    def formattingParam(self, channel):
        if 'power' in channel:
            self._units = 'W'
            self._measuredQuantity = "Power"
            self._scalingCoefficient = 0.1
        elif 'voltage' in channel:
            self._units = 'V'
            self._measuredQuantity = "Voltage"
            self._scalingCoefficient = 0.1
        elif 'current' in channel:
            self._units = 'A'
            self._measuredQuantity = "Current"
            self._scalingCoefficient = 0.001
        elif 'PF' in channel:
            self._units = None
            self._measuredQuantity = "Power Factor"
            self._scalingCoefficient = 0.01
        elif 'Hz' in channel:
            self._units = 'Hz'
            self._measuredQuantity = "Line Frequency"
            self._scalingCoefficient = 0.1
        elif 'VA' in channel:
            self._units = 'V*A'
            self._measuredQuantity = "Volt-Amps"
            self._scalingCoefficient = 0.1

    # /reporting/create
    def reportingCreate(self):
        params = json.dumps( {
            'DeliveryLocation' : self._location,
            'DeliveryResource' : self._resource,
            'Period'           : self._period,
            'MinPeriod'        : None,
            'MaxPeriod'        : None,
            'ExpireTime'       : None,
            'Capability'       : None
        } )
        responseJson = self.postJson(self._reportingCreateURL, params)
        self._responseURLs = json.loads(responseJson)   # response all URLs
        print "Response =", self._responseURLs
    
    # /data/reading
    def dataReading(self):
        schemaURL = self._responseURLs['ReadingURL']    # has its own URL
        params = json.dumps( { 
            'schema'          : {'ref' : schemaURL}, 
            'Version'         : 1,
            'Reading'         : self._reading,
            'ReadingTime'     : self._readingTime,
            'ReadingSequence' : self._readingSeq
        } )
        self._dataReadingResponse = self.postJson(schemaURL, params)
        print "Reading =", self._dataReadingResponse
    
    # /data/formatting
    def dataFormatting(self):
        schemaURL = self._responseURLs['FormattingURL']    # has its own URL
        params = json.dumps( {
            'schema'             : {'ref' : schemaURL}, 
            'Version'            : 1,
            'Units'              : self._units,
            'MeasuredQuantity'   : self._measuredQuantity,
            'ScalingCoefficient' : self._scalingCoefficient
        } )
        self._dataFormattingResponse = self.postJson(schemaURL, params)
        print "Formatting =", self._dataFormattingResponse
    
    # /data/parameter
    def dataParameter(self):
        schemaURL = self._responseURLs['ParameterURL']    # has its own URL
        params = json.dumps( {
            'schema'             : {'ref' : schemaURL}, 
            'Version'            : 1,
            'SamplingFrequency'  : self._samplingFrequency
        } )
        self._dataParameterResponse = self.postJson(schemaURL, params)
        print "Parameter =", self._dataParameterResponse

    def run(self):
        if self._initFlag:
            for channel in self._resourceList:
                self._resource = channel
                self.reportingCreate()
                if channel not in self._responseURLdict:
                    self._responseURLdict[channel] = self._responseURLs
                self.formattingParam(channel)
                self.dataFormatting()
                self.dataParameter()            
            self._initFlag = False
        while True:
            self._line = self._serial.readline()
            self._readingSeq += 1
            for channel in self._resourceList:
                self._responseURLs = self._responseURLdict[channel]
                self.startSampling(channel)
                self.dataReading()
            time.sleep(self._period)


def configParam(configFileName):
    configDir = os.path.dirname(sys.argv[0])
    if not configDir:
        configDir = os.getcwd()
    argList = []
    try:
        configFile = open(configDir + "/" + configFileName)
        for line in configFile:
            line = line.strip()
            if '#' in line:
                line, comment = line.split('#', 1)
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
    argList = configParam("wattsup_json.conf")
    for arg in argList:
        if 'ServerIPAddress' in arg:
            reportingCreateURL = arg[1]
            argList.remove(arg)
    try:
        for arg in argList:
            device = WattsUpDevice(reportingCreateURL, arg[0], arg[1], int(arg[2]), arg[3:])
            device.daemon = True
            device.start()
        while True:
            time.sleep(100)
    except (KeyboardInterrupt, SystemExit):
        print '\nReceived keyboard interrupt, quitting all child threads!\n'

if __name__ == "__main__":
    main()

    
    
