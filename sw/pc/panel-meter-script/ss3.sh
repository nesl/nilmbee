#!/bin/bash

LOGPATH=$1
if [ -z "$LOGPATH" ]; then
  LOGPATH=log1
else
  mkdir $LOGPATH
fi

while [ 1 ]; do 
  DATA1=`./TCPModbusClient r 172.17.5.178 4660 1 2083 40 2>&1 | grep -A 1 float | grep "\."`
  DATA2=`echo "$DATA1" | ./sum.py`
  TIME=`date +%s.%N`
#  sleep 0.1
#  DATA2=`./TCPModbusClient r 172.17.5.178 4660 1 2167 40 2>&1 | grep -A 1 float | grep "\."`
  if [ -n "$DATA1" ] && [ -n "$DATA2" ]; then
    echo "$TIME" | tee -a $LOGPATH/time.log
    echo "$DATA1" | tee -a $LOGPATH/kw-sep.log
    echo "$DATA2" | tee -a $LOGPATH/kw.log
    sleep 2
  fi
done

