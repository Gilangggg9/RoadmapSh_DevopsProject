#!/bin/bash
echo "===== Server Performance Stats ==== "
#You are required to write a script server-stats.sh that can analyse basic server performance stats. You should be able to run the script on any Linux server and it should give you the following stats:
#Total CPU usage
echo ">> Total CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4"%"}'

#Total memory usage (Free vs Used including percentage)
echo ">> Memory Usage:"
free -m | awk 'NR==2{printf "Used: %s MB | Free: %s MB | Usage: %.2f%%\n", $3,$4,$3*100/$2 }'

#Total disk usage (Free vs Used including percentage)
echo ">> Disk Usage:"
df -h --total | grep "total" | awk '{printf "Used: %s | Free: %s | Usage: %s\n", $3,$4,$5}'

#Top 5 processes by CPU usage
echo ">> Top 5 Processes by CPU:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

#Top 5 processes by memory usage
echo ">> Top 5 Processes by Memory:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

echo "===================================="




