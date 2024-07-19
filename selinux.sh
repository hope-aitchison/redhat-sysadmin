#!/bin/bash

## SELINUX - the internal firewall

# selinux status
getenforce
# change selinux status
sudo setenforce # Enforcing or Permissive

# manage default state here
/etc/sysconfig/selinux

# SELinux state can be set at boot time using a kernel parameter
enforcing=0 # start in permissive mode
enforcing=1 # start in enforcing mode

selinux=0 # start in permissive mode
selinux=1 # start in enforcing mode

## disable selinux from grub menu 
sudo reboot
e # edit
.../swap selinux=0
ctrl^x
# overwrites the system settings
# reboot again and change back for enforcing

# managing context labels
semanage fcontext 

# see manual pages for examples
man semanage-fcontext


############################################
## basic relabelling example
sudo touch /var/www/html/example.html
sudo ls -Z var/www/html/example.html
# system_u:object_r:httpd_sys_content_t:s0 /var/www/html/example.html

mkdir ~/selinux/
cd ~/selinux
sudo mv /var/www/html/example.html ~/selinux/example_2.html
# system_u:object_r:httpd_sys_content_t:s0 example_2.html
# system_u:object_r:user_home_t:s0 file1.txt

getenforce
sudo semanage fcontext -a -t user_home_t example_2.html
sudo restorecon -v example_2.html # -v adds verbosity and shows label change
# Relabeled /home/hope/selinux/example_2.html from system_u:object_r:httpd_sys_content_t:s0 to system_u:object_r:user_home_t:s0

############################################
## html file example
cp /etc/hosts ~/hosts
mv ~/hosts /var/www/html/
ls -Z /var/www/html/hosts
sudo restorecon -vR /var/www/html/
# Relabeled /var/www/html/hosts from system_u:object_r:user_home_t:s0 to system_u:object_r:httpd_sys_content_t:s0

sudo vim /etc/httpd/conf/http.conf
:/DocumentRoot
DocumentRoot "/web"
:wq!

sudo su 
mkdir /web
vim /web/index.html
Well hello there amigo
:wq!

systemctl restart httpd
curl localhost # just shows default welcome page, not "Well hello there amigo"

# troubleshoot
sudo setenforce permissive
curl localhost
# still default page so selinux not currently the issue

sudo vim /etc/httpd/conf/httpd.conf
...
# Relax access to content within /var/www.
#
# <Directory "/var/www">
<Directory "/web"> # this is where the index.html is stored
:wq!

sudo systemctl restart httpd
curl localhost
# works!

sudo setenforce enforcing
curl localhost # no longer works, need to fix selinux

sudo su
grep AVC /var/log/audit/audit.log # AVC - selinux related log messages identifier
...
avc:  denied  { getattr } ... comm="httpd" path="/web/index.html" ... //
scontext=system_u:system_r:httpd_t:s0 ..// # apache web server
tcontext=system_u:object_r:root_t:s0 // # index.html file
tclass=file
# source is trying to get attributes of the target
# so apache service coming in with httpd_t trying to access a target with default_t - labels do not match

man semanage-fcontext # check the examples
sudo semanage fcontext -a -t httpd_sys_content_t "/web(/.*)?" # regexp that means you apply context to all that might exist within /web
sudo restorecon -vR /web
# Relabeled /web from system_u:object_r:root_t:s0 to system_u:object_r:httpd_sys_content_t:s0
ls -Z /web
# system_u:object_r:httpd_sys_content_t:s0 index.html
curl localhost 
Well hello there amigo

####################################
## finding the right context
dnf search selinux 
dnf install -y selinux-policy-doc

man -k _selinux # shows all pages available
man -k _selinux | grep httpd # specifically searches for anything httpd related (see above example)

man httpd_selinux # search for the context label

# check what the expected selinux label of a file should be
matchpathcon /path/to/file 

# location of all default file policies
/etc/selinux/targeted/contexts/files/file_contexts

#####################################
## SELinux port context labels

# check expected / default port label 
semanage port -l | grep 22

# search in augit logs for anything related
grep AVC /var/log/audit/audit.log | grep sshd # selinux uses auditd for logging

# update a port to use a new label
semanage port -a -t ssh_port_t -p tcp 2202

#####################################
## SELinux booleans

# Overview of all booleans
semanage boolean -l
getsebool -a

# to change booleans
setsebool -P boolean-name on/off # P for persistent

# check for non default settings
semanage boolean -l -C

# example
getsetbool -a | grep ftp
setsebool -P ftpd_anon_write on
semanage boolean -l -C
