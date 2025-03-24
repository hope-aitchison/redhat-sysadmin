#!/bin/bash

NFS - Network File System
Allows linux systems to share directories and files over a network 
Access remote file systems as if they were local

#######################################
## NFS local server

dnf install nfs-utils
sudo systemctl enable --now nfs-server

# create directory to share

mkdir -p /home/ldap/ldapuser{1..2}

# add entries to exports 

echo "/nfsdata *(rw,no_root_squash)" >> /etc/exports
echo "/home/ldap *(rw,no_root_squash)" >> /etc/exports

# no_root_squash allows root user actions on the client to retain root privileges on the server

# apply export changes
sudo exportfs -r

# verify NFS exports
showmount -e

# enable NFS firewall settings

firewall-cmd --get-services | mount / rpc / nfs # to find the exact names

for i in mountd rpc-bind nfs; do firewall-cmd --add-service $i --permanent; done
firewall-cmd --reload
firewall-cmd --list-services

systemctl start nfs-server
systemctl start rpcbind

## NFS client server
dnf install nfs-utils
sudo systemctl enable --now nfs-server

# create a mount point 
mkdir -p /nfsdata

# mount the NFS share
mount -t nfs IP:/home/ldap/ldapuser{1..2} /nfsdata

# verify 

showmount -e IP
# output generated
Export list for IP:
/home/ldap *
/nfsdata   *

# temp test 
mount localhost:/nfsdata /mnt

# unmount a shared directory

umount /nfsdata
umount -l /nfsdata