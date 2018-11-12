#!/bin/bash
while sleep 30
available_memory=`free -m | grep Mem | awk '{printf $7}'`
do
    if [ $available_memory -lt 500 ]
    then
        killall -9 ruby
	notify-send "It had to be done man. We killed them all. Sorry."
    fi
done
