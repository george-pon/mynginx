#!/bin/bash
#
# 1. TCPコネクション数をカウント。0になったら終了。
# 2. 指定時間を超えたら終了。
#

export LANG=C

MAX_WAIT=3600
COUNT=0

if [ $# -eq 1 ]; then
    MAX_WAIT=$1
    echo "MAX_WAIT is set to $1"
fi

while true
do
    NUM=$( ss -ant | grep ESTAB | wc -l )
    echo "ESTAB: $NUM  ( $COUNT / $MAX_WAIT )"
    if [ $NUM -eq 0 ]; then
        echo "SUCCESS."
        break
    fi
    sleep 5
    COUNT=$(( COUNT + 5 ))
    if [ $COUNT -gt $MAX_WAIT ]; then
        echo "TIMEOUT."
        break
    fi
done

#
# end of file
#
