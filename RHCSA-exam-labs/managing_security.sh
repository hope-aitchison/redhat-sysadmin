#!/bin/bash

## Permissions
# Configure access to /data/staff directory such that it meets the following requirements:
# * Members of group staff have full access
# * Group members can only delete files they have created
# * directory cotains rootfile which can be read by group members but not deleted by anyone
# * leave all other user and permissions settings at their default

# give staff group full access
mkdir -p /data/staff
chmod 0775 /data/staff
chgrp staff /data/staff
ls -ld /data/staff
drwxrwxr-x. 2 root staff 6 Jan 10 09:56 /data/staff/

# group members can only delete files they have created
chmod +t /data/staff
ls -ld /data/staff
drwxrwxr-t. 2 root staff 22 Jan 10 10:17 /data/staff/

# rootfile can be read by group members but not deleted by anyway
touch /data/staff/rootfile
ls -l /data/staff/
-rw-r--r--. 1 root root 0 Jan 10 10:17 rootfile
chattr +i /data/staff/rootfile # immutable attribute
lsattr /data/staff/rootfile
----i----------------- rootfile


## Managing SELinux file context
# Install the vsftpd service
# configure so that anonymous uploads are permitted
# * anonymous_upload options enabled in /etc/vsftpd/vsftpd.conf
# * permission mode 777 set on /var/ftp/pub directory
# * SELinux configured accordingly
# test anonymous file upload, install lftp client, use the following:
# * open a session using lftp localhost
# • use cd pub
# * use put /etc/hosts




## Configuring SSH

## Managing SELinuc port context