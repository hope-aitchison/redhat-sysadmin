#!/bin/bash

## Restricting network access
# Configure your system such that the httpd service is accessible for external 
# users on port 80 and 443 using its default configuration

dnf install -y firewalld
systemctl start firewalld

firewall-cmd --list-services
firewall-cmd --get-services
firewall-cmd --add-services http https --permanent

firewall-cmd --list-services
systemctl restart firewalld
firewall-cmd --list-services


## Configuring hostname resolution
# Set your hostname to examlabs.local
# Ensure that this hostname is resolved to the IP address that your host is using

hostnamectl set-hostname examlabs.local

ip a # obtain the local server IP address
vim /etc/hosts
...
IP address      examlabs.local # ensure hostname resolves to correct IP address
:wq

ping examlabs.local