#!/bin/bash 

chronyd
man chronyd
"chronyd is a daemon for synchronisation of the system clock "
 
vim /usr/lib/systemd/system/chronyd.service
"NTP client/server"

# parameters
/etc/chronyd.conf

## update server to use pool.ntp.org
timedatectl status # check ntp server active
vim /etc/chronyd.conf
pool pool.ntp.org

systemctl restart chronyd
chronyc sources

timedatectl # check or change timezones

