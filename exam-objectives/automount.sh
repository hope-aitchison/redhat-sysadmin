#!/bin/bash

###########################################
## automount
# automatically mounts and unmounts filesystems based on activity

dnf install -y autofs
systemctl enable --now autofs

automount # daemon
autofs # config files

# autofs uses master and map files

# master file
/etc/auto.master # global autofs settings

# map file
/etc/auto.nfs 

# identify the directory (mountpoint) autofs should manage
# state the config file to be used for this mountpoint

# master file
/nfsdata /etc/auto.nfs --timeout=300 # base mount point, map file, unmount after 5 mins inactivity


# map file
files   -rw IP:/nfsdata # subdirectory, mount options, NFSserver and exported directory

# mounts on IP:/nfsdata

systemctl restart autofs
systemctl enable autofs

# verify from remote machine
ls /nfsdata
cd /nfsdata/files

mount | tail -3
mount | grep autofs

###########################################
## multui user example
mkdir -p /home/ldap/ldapuser{1..9}
echo "/home/ldap *(rw,no_root_squash)" >> /etc/exports

vim /etc/auto.master
...
/homes      /etc/auto.homes

vim /etc/auto.homes
*   -rw     localhost:/home/ldap/

systemctl restart auto-fs
systemctl status auto-fs

mount | tail -5

cd /homes/
ls -a # empty
cd ldapuser1
# works! and now directory visible too

###########################################
## exam style question
# use localhost & configure NFS 
# on localhost create home directories /home/user/user{1..9}
# configure nfs to export these home directories
# automount these home directories on /userhomes/

# set up localhost to be accessible via ssh
sudo -i
cd /root/.ssh/
ssh-keygen -t rsa -b 4096
cat id_rsa.pub >> authorized_keys
chmod 600 id_rsa.pub

ssh localhost
# works

mkdir -p /home/user/user{1..9}

# configure nfs to export these directories
vim /etc/export
/home/user      *(rw,no_root_squash)

systemctl restart nfs-server
systemctl status nfs-server
showmount -e localhost
# shows the /home/user directory as exported

# create automount config
vim /etc/auto.master
...
/userhomes      /etc/auto.users

vim /etc/auto.users
*   -rw     localhost:/home/user/&  

systemctl restart autofs
mount | tail -5
# shows /etc/auto.users on /userhomes type autofs

cd /userhomes/user1
cd /userhomes/user9
# success!







