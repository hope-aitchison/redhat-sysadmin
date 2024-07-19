#!/bin/bash

dnf install -y firewalld
dnf install -y nfs-utils

sudo -i
vim /etc/exports # NFS configuration

systemctl status nfs-server
systemctl enable nfs-server
# Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service
systemctl start nfs-server

sudo firewall-cmd --state
systemctl start firewalld
sudo firewall-cmd --reload

sudo -i
for x in rpc-bind mountd nfs; do firewall-cmd --add-service $x --permanent; done
sudo firewall-cmd --reload
sudo firewall-cmd --list-services

ip a
inet # localhost IP
eth0 # public IP

## Exam style question
# On Server2 create the directories /homes/user1 and /homes/user2
# Use NFS to share these directories and ensure the firewall does not block access to these directories
# On Server1 create a solution that automatically, on-demand, mounts server2:/homes/user1 on /homes/user1
# & also that automatically, on-demand mounts server2:/homes/user2 on /homes/user2 when these directories are accessed.

sudo -i
useradd hope
groupmod -a wheel -U hope
passwd hope
####
exit

su - hope

cat /etc/hosts
# localhost

mkdir ~/.ssh/
chmod 700 ~/.ssh/
ssh-keygen -b 4096 -t rsa
cat id_rsa.pub >> authorized_keys
chmod 600 authorized_keys

ssh hope@localhost
# add key

hostnamectl set-hostname localhost
exit

ssh hope@localhost
sudo mkdir -p /homes/user{1,2}
sudo vim /etc/exports
/homes		*(rw,no_root_squash)

sudo systemctl enable nfs-server
sudo systemctl start firewalld

sudo firewall-cmd --list-services
for i in rpc-bind mountd nfs; do sudo firewall-cmd --add-service $i --permanent; done
sudo firewall-cmd --reload
sudo firewall-cmd --list-services
# cockpit dhcpv6-client mountd nfs rpc-bind ssh

sudo dnf install -y nfs-utils autofs

