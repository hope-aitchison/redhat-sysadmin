#!/bin/bash

#######################################
## NFS base server

dnf install nfs-utils

mkdir -p /nfsdata /home/ldap/ldapuser{1..2}

echo "/nfsdata *(rw,no_root_squash)" >> /etc/exports
echo "/home/ldap * (rw,no_root_squash)" >> /etc/exports

# no_root_squash allows root user actions on the client to retain root privileges on the server

systemctl enable nfs-server

firewall-cmd --get-services | mount / rpc / nfs # to find the exact names

for i in mountd rpc-bind nfs; do firewall-cmd --add-service $i --permanent; done
firewall-cmd --reload
firewall-cmd --list-services

systemctl start nfs-server
systemctl start rpcbind

showmount -e localhost
# output generated
Export list for localhost:
/home/ldap *
/nfsdata   *

# temp test 
mount localhost:/nfsdata /mnt
