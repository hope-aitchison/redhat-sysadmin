#!/bin/bash 

# Locate and Interpret System Log Files and Journals

journald # system logging

# log file locations

/var/log/messages # general system logs
/var/log/secure # authentication logs
/var/log/cron # cron logs
/var/log/yum.log # package installation logs

journalctl # view all logs

jouralctl -u service-name # logs for a specific unit

journalctl -f # view all logs in realtime 

# preserve system logs

/run/log/journal # default non-persistant storage
# does not persist across reboots

mkdir -p /var/log/journal # create persistant journal

sytemctl status systemd-journald

# edit this file
/etc/systemd/journal.conf
Storage=Auto

systemctl restart systemd-journald
sudo reboot # reboot system

journalctl --verify # see where logs are sent to
ls -lh /var/log/journal/








