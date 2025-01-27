#!/bin/bash

## Mounting filesystems
# mount the lvlabs LVM logical volume created in local-storage.sh on /lvlabs
# ensure no executable files can be started from it
# ensure file access time is not updated while files are accessed

mkdir /lvlabs
vim /etc/fstab

/dev/vglabs/lvlabs       /lvlabs xfs     noexec,noatime  0       0

## Managing autofs
# configure autofs such that the device /dev/sda1 is mounted on the directory
# /start/files when this directory is accessed

vim /etc/auto.misc # for inspo!

dnf install -y autofs
vim /etc/auto.master

/start  /etc/auto.start

vim /etc/auto.start
files   -fstype=xfs     :/dev/nvme1n1p1

systemctl enable --now autofs
systemctl status autofs

cd /
# check to see that /start directory now present
cd start/
ls # empty
cd files # should now be able to enter the files directory

mount -l | grep autofs
/etc/auto.misc on /misc type autofs (rw,relatime,fd=7,pgrp=18334,timeout=300,minproto=5,maxproto=5,indirect,pipe_ino=56778)
/etc/auto.start on /start type autofs (rw,relatime,fd=10,pgrp=18334,timeout=300,minproto=5,maxproto=5,indirect,pipe_ino=56016)
-hosts on /net type autofs (rw,relatime,fd=13,pgrp=18334,timeout=300,minproto=5,maxproto=5,indirect,pipe_ino=56782)
/dev/nvme1n1p1 on /start/files type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,sunit=8,swidth=8,noquota)
# this last one in particular should be what you are looking for

lsblk
└─nvme1n1p1 259:6    0    2G  0 part /start/files

## Resizing LVM volumes
# Add 10 GiB to the logical volume on which the root filesystem is mounted.
# Configure any additional required devices up to your discretion.

vgs
  VG     #PV #LV #SN Attr   VSize  VFree
  vglabs   1   1   0 wz--n- <2.00g 1.00g
# only 1 GB available in vglabs - not enough
# need to start by creating a PV and adding to the VG

fdisk /dev/nvme1n1
p, F
# I only have <8.0 GB available, proceeding with 7 GB

n, 2, +7G, t = lvm, w
lsblk # to confirm

vgextend vglabs /dev/nvme1n1p2 # add the new physical volume to the vg
vgs 
  VG     #PV #LV #SN Attr   VSize VFree
  vglabs   2   1   0 wz--n- 8.99g <8.00g

mkfs.ext4 /dev/vglabs/lvlabs # needs a fs to be extended

lvextend -r -L +7G /dev/vglabs/lvlabs # extend the lv & resize the fs
lvs 
  LV     VG     Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvlabs vglabs -wi-a----- <8.00g


## Configuring directories for collaboration
# Create a group sales with users lisa and lori as its members 
# Ensure the group sales has full access to /data/sales
# All files created in data/sales should be group-owned by the group sales
# Ensure that files can only be deleted by the user that created the file
# as well as user lisa (member of group sales).

groupadd sales
useradd lisa -G sales
useradd lori -G sales
mkdir -p /data/sales

chown root:sales /data/sales
ls -l /data/sales

chmod g+s /data/sales
chmod g+w /data/sales
# ensures all files created in /sales are group owned

chmod +t /data/sales
# sticky bit ensures files can only be deleted by the user who made the file

chown lisa:sales /data/sales
# ensures that lisa can delete files in /sales

ls -l /data/sales
drwxrws--t. 2 lisa sales 6 Dec 23 17:30 sales
