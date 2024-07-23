#!/bin/bash

jobs # check what jobs are running

sleep 1000
....
ctrl-z # kills the sleep 1000 job

sleep 2000 & # run the command in the background
jobs 
[1]-  Running                 sleep 2000 &

fg 1 # brings job 1 into the foreground
ctrl-z # kills job 
jobs
[1]+  Stopped                 sleep 2000

###########################################
## process state

# zombie - when process has completed task / exited but hasn't collected execution status
# PID not released
# kill the parent process

ps # all current processes
ps aux # extra info

ps aux | less # good for PIDS
ps fax # hierarchy of processes
ps -fU user # all processes owned by a certain user
pd aux | grep defunct # shows zombie processes


# check free memory
free -m 
vim /proc/meminfo

# check cpu load / statistics
uptime

# check number of cpu cores
lscpu 

# dashboard showing system activity
top

# kill signals
kill # with PID
k # in top dashboard
kill -9 # high risk
killall command # kills all processes running for command

# to kill a zombie
ps aux | grep defunct # get PID 
kill -sigchild PID # zombie will be reaped
kill parent-PID
# zombie adopted by init
ps aux | grep defunct


###########################################
## systemctl

# service unit files here
/usr/lib/systemd/system/ # do not edit

systemctl edit httpd.service
[Service]
Restart=always
RestartSec=30s
# look at other .service files for syntax 

ps aux | grep httpd 
killall httpd
ps aux | grep httpd 
# nothing running
....

systemctl status httpd.service
active!
/etc/systemd/system/httpd.service.d/override.conf # location of custom drop in file


###########################################
## tuned
# a systemd service
# tunables located in /proc/

tuned-adm list # current profiles

/etc/tuned/tuned-main.conf

# creating a unique tuned profile
# edit a tunable - for testing
echo vm.swappiness = 33 > /etc/sysctl.d/swappiness.conf
sysctl -p /etc/sysctl.d/swappiness.conf
# vm.swappiness = 33
# default is 30 /proc/sys/vm/swappiness

sysctl -a | grep swappiness
# 33

mkdir -p /etc/tuned/myprofile

cat >> /etc/tuned/myprofile/tuned.conf <<EOF
> [sysctl]
> vm.swappiness = 66
> EOF

cat /etc/tuned/myprofile/tuned.conf

tuned-adm profile myprofile
# Current active profile: myprofile

sysctl -a | grep swappiness
# 33

vim /etc/tuned/tuned-main.conf
reapply_sysctl = 1 # overrides any changes made