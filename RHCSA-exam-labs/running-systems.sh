#!/bin/bash

## Managing systemd

# use package manager to install nginx and httpd service
# configure systemd to make it so that nginx can never be started
# httpd should be started when the server boots
# make it so that if httpd is stopped for whatever reason it starts again after 21s

dnf install -y httpd nginx

# both of these services use port 80

systemctl mask nginx
systemctl status nginx
○ nginx.service
     Loaded: masked (Reason: Unit nginx.service is masked.)
     Active: inactive (dead)

systemctl enable httpd
# means the service starts upon server boot

systemctl cat sshd.service # any service here will do
# copy this section
Restart=on-failure
RestartSec=42s

systemctl edit httpd.service # this edits the override.conf file rather than system file
[Service]
Restart=on-failure
RestartSec=21s

systemctl daemon-reload
systemctl status httpd
systemctl start httpd
# get the pid
kill -9 pid

systemctl status 
httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; preset: disabled)
    Drop-In: /etc/systemd/system/httpd.service.d
             └─override.conf
     Active: activating (auto-restart) (Result: signal) since Wed 2024-12-18 17:25:38 UTC; 1s ago
       Docs: man:httpd.service(8)

# wait 21s
systemctl status httpd
# confirm running again

## Tuning

# Configure your system for optimum power usage efficiancy

tuned-adm list profile
# to see all available profiles

tuned-adm profile powersave
tuned-adm active
Current active profile: powersave

