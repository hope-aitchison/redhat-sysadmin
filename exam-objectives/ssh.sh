#!/bin/bash

# localhost IP & alias
cat /etc/hosts

# ssh config
cat /etc/ssh/sshd_config

# generate ssh key
cd ~/.ssh/
ssh-keygen -t rsa -b 4096 
cat id_rsa.pub >> ~/.ssh/authorized_keys

# set correct access permissions
chmod 700 ~/.ssh/
chmod 600 ~/.ssh/authorized_keys

# check the filepath for keys
sudo cat /etc/ssh/sshd_config | grep keys
# AuthorizedKeysFile	.ssh/authorized_keys

systemctl status sshd
ssh user@localhost

# ssh logs
tail -f /var/log/secure

# scp with ssh
touch hello.txt
scp hello.txt hope@localhost:/tmp
ssh hope@localhost ls -l /tmp/ # check files has been copied

# sync directories with rsync
touch shopping{1..5}.txt
rsync -a * localhost:/tmp/
ssh hope@localhost ls -l /tmp/

# sshd_config edits to allow root login and X11 graphical forwarding via ssh
sudo -i
vim /etc/ssh/sshd_config
X11Forwarding yes
PermitRootLogin yes
Port 22

systemctl restart sshd
ssh root@localhost
# make sure key available in .ssh

# install GNOME text editor
dnf install -y gedit
ssh -X localhost gedit

X11 forwarding allows users to run graphical applications on a remote server & interact  
using their local device.

# allow certain users only

vim /etc/ssg/sshd_config
AllowUsers hope bart

systemctl restart sshd # always restart daemon after making changes to config


