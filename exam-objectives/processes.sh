#!/bin/bash

# processes

man ps # current processes

ps -aux # detailed running processes

# CPU / memory processes

top 
P # order by process
M # order by memory

ps -aux --sort=-%mem | head -n 10 # top ten memory processes

# kill

kill PID # terminate a process

kill -9 PID # force kill

pkill -9 firefox # force kill a process by name

killall -9 httpd # kill all running httpd processes

# process scheduling

nice # start a process with a specific priority
NI = nice = ranges from -20 (highest priority) to 19 (lowest priority)
0 = default

ps -eo pid,ni,comm --sort=ni | head -n 10
# list top ten priority processes

nice -n 10 myscript.sh # runs script with a priority of 10

renice # alter the priority of a running process

renice -n -5 -p 1234 # sets priority using process PID

ionice # control disk I/O scheduling

class 1 = real time
class 2 = best effort
class 3 = idle

ionice -c 2 -n 5 -p 1234

# tuning profiles

tuned-adm # switch between different profiles

systemctl enable --now tuned # enable and start if not running 

balanced (default): General-purpose profile.
performance: Optimized for performance.
powersave: Reduces power consumption.
network-latency: Optimized for low network latency.
throughput-performance: Optimized for high network/storage throughput.
