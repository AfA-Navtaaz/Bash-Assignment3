#!/bin/bash

source process_monitor.properties

while true; do
# Get process ID
    pid=$(pgrep $process_name)

# Check if process is running
    if [ -z $pid ]
    then
        echo "Process not found"
        exit 1
    fi

#checking CPU usage 
tput clear
tput cup 1 0

    cpu_usage=$(ps -p $pid -o %cpu,%mem | sed '1d' | awk '{ print $1 }')

    if (( $(echo "$cpu_usage > $cpu_threshold" | bc ) ));
    then
        echo "High Usage of CPU"
    fi

 #checking Memory usage

    mem_usage=$(ps -p $pid -o %cpu,%mem | sed '1d' | awk '{ print $2 }')

    if (( $(echo "$mem_usage > $mem_threshold" | bc ) ));
    then
        echo "High usage of Memory"
    fi

 #checking Storage usage

    storage_usage=$(df -h $direc | sed '1d' | awk '{print $5}' | sed 's/%//')

    if (( $(echo "$storage_usage > $storage_threshold" | bc ) ));
    then
        echo "Storage limit exceeded"
    fi
    
 #checking Network usage

    net_usage=$(ifconfig $net_interface | grep "RX packets" | awk '{print $5}')

    if (( $(echo "$net_usage > $net_threshold" | bc ) ));
    then
        echo "Network traffic limit exceeded"
    fi

    sleep 5
done