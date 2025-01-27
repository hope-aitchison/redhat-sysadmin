#!/bin/bash

## Scheduling tasks
# Create a scheduled task that runs as user "linda" on weekdays at 2:00 AM
# The task should write "greetings from Linda" to the actual system logging service

systemctl status crond

crontab -e -u linda
0 2 * * 1-5 logger greetings from linda
# recommended to add a test for exam
* * * * * logger TESTING # runs every minute
:wq

crontab -l -u linda

cat /var/log/cron
...
Dec 24 11:58:02 ip-10-0-101-30 CROND[14967]: (linda) CMDEND (logger TESTING)

journalctl -f # to see logger output in realtime
Dec 24 12:07:01 ip-10-0-101-30.eu-west-2.compute.internal linda[15114]: TESTING

## Configuring time services
# configure your server to fetch time from pool.ntp.org
# set timezone to Africa/Lusaka

timedatectl show
# see current settings
timedatectl list-timezones
timedatectl set-timezone Africa/Lusaka
timedatectl show

vim /etc/chrony.conf
pool pool.ntp.org
:wq

systemctl restart chronyd.service

