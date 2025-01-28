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

NI = nice = ranges from -20 (highest priority) to 19 (lowest priority)

ps -eo pid,ni,comm --sort=ni | head -n 10
# list top ten priority processes
