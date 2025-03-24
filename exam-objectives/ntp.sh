#!/bin/bash 

chronyd
man chronyd
"chronyd is a daemon for synchronisation of the system clock "
 
vim /usr/lib/systemd/system/chronyd.service
"NTP client/server"

dnf install chronyd
systemctl enable chronyd

# configuration file
/etc/chronyd.conf

# specify an NTP server
vim /etc/chronyd.conf
server 0.pool.ntp.org iburst
server 1.pool.ntp.org iburst
server 2.pool.ntp.org iburst

## update server to use pool.ntp.org
timedatectl status # check ntp server active
vim /etc/chronyd.conf
pool pool.ntp.org

systemctl restart chronyd
chronyc sources

timedatectl # check or change timezones

