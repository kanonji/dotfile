#!/bin/bash
COUNT=2
while [ $COUNT -lt 255 ]; do
    ifconfig lo0 alias 127.0.0.$COUNT
    COUNT=$(( COUNT + 1 ))
done
