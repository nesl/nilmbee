#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Usage: batchprogram.sh node_id [last_node_id]"
    echo "Program a single node or multiple nodes from node_id to last_node_id (inclusive)"
else
    s="$1"
    if [ -z "$2" ]; then
        echo "const uint8_t NODE_ID = $s;" > nodeid.h
        echo "Press any key to programming node #$s ..."
        read -n1 -s
        make program
        echo "Finished"
    else
        echo "Programming node #$s - #$2 ..."
        while [ "$s" -le "$2" ]; do
            echo "const uint8_t NODE_ID = $s;" > nodeid.h
            echo "Press any key to programming node #$s ..."
            read -n1 -s
            make program
            s=`expr $s + 1`
        done
        echo "Finished"
    fi
fi

