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

# vsftpd very secure file transfer protocol daemon
# lftp command line file transfer client

dnf install -y vsftpd
dnf install -y lftp

# install sealert
dnf provides */sealert
dnf install -y setroubleshoot-server
systemctl status auditd # logging daemon needed to detect selinux based error logs

getenforce
Enforcing

vim /etc/vsftpd/vsftpd.conf
anon_upload_enable=YES
write_enable=YES

chmod 777 /var/ftp/pub/
ls -l /var/ftp/pub/

vim /etc/vsftpd/vsftpd.conf # this file contains SELinux booleans for ftp
# When SELinux is enforcing check for SE bool allow_ftpd_anon_write, allow_ftpd_full_accesss

getsebool -a | grep ftpd # check current boolean settings for ftpd records
ftpd_anon_write --> off
ftpd_connect_all_unreserved --> off
ftpd_connect_db --> off
ftpd_full_access --> off
ftpd_use_cifs --> off
ftpd_use_fusefs --> off
ftpd_use_nfs --> off
ftpd_use_passive_mode --> off
httpd_can_connect_ftp --> off
httpd_enable_ftp_server --> off
tftp_anon_write --> off
tftp_home_dir --> off

setsebool -P ftpd_anon_write=1 # P for persistence 
setsebool -P ftpd_anon_write on # also works


lftp localhost
cd pub # works
put /etc/hosts # denied 

# install sealert
dnf provides */sealert
dnf install -y setroubleshoot-server

journalctl | grep sealert
SELinux is preventing .... from write access on directory pub

sealert -l XXXX | less
# this will provide the correct fconext setting required
# also tells you the commands required!

man semanage-fcontext # list commands and restore command

ls -ldZ /var/ftp/pub/ # check the current setting on the directory to be accessed via ftp
drwxrwxrwx. 2 root root system_u:object_r:public_content_t:s0 6 Aug 20 08:52 /var/ftp/pub/

public_content_t # this is the current setting and is read only access

# check what else is available for thie policy - if cannot use sealert
semanage fcontext --list | grep public_content
/srv/([^/]*/)?ftp(/.*)?                            all files          system_u:object_r:public_content_t:s0
/srv/([^/]*/)?rsync(/.*)?                          all files          system_u:object_r:public_content_t:s0
/var/ftp(/.*)?                                     all files          system_u:object_r:public_content_t:s0
/var/ftp/pub                                       all files          system_u:object_r:public_content_rw_t:s0
/var/spool/abrt-upload(/.*)?                       all files          system_u:object_r:public_content_rw_t:s0

public_content_rw_t # this will give read write access

semanage fcontext -a -t public_content_rw_t /var/ftp/pub/
restorecon -vR /var/ftp/pub/

ls -ldZ /var/ftp/pub/
drwxrwxrwx. 2 root root system_u:object_r:public_content_rw_t:s0 33 Jan 11 12:46 /var/ftp/pub

systemctl restart vsftpd

lftp localhost 
cd pub
put /etc/hosts
# works!

## Configuring SSH
# configure ssh such that only users student and linda are allowed to open a session to the ssh host

man sshd_config

vim /etc/sshd/sshd_config
...
AllowUsers student linda
PasswordAuthentication yes

ssh student@localhost

## Managing SELinuc port context
# configure the httpd service to listen on port 82 only

dnf install -y httpd
dnf provides */sealert

dnf install -y setroubleshoot-server

vim /etc/httpd/conf/httpd.conf
...
Listen 82

systemctl start httpd
Job for httpd.service failed because the control process exited with error code.
See "systemctl status httpd.service" and "journalctl -xeu httpd.service" for details.

journalctl | grep sealert

man semanage
man semanage-port # has a very good example!

semanage port -l | grep httpd
semanage -a -t http_port_t -p 82
semanage port -l | grep httpd_port_t
http_port_t     tcp      82, 80, 81, 443, 488, 8008, 8009, 8443, 9000 # port now added

systemctl start httpd
systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; preset: disabled)
     Active: active (running) since Mon 2025-01-13 14:43:26 UTC; 8min ago
