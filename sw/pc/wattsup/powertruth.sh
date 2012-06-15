#!/bin/bash

mkdir truth

t1=`head -n 1 time.log | cut -d. -f1`
t2=`tail -n 1 time.log | cut -d. -f1`

for i in 1 2 3 4 5 7 8 12 13 14 17 18 21
do
    wget -O truth/$i.log "http://172.17.5.53/wattsup_log/query.php?id=$i\&t1=$t1\&t2=$t2"
done

