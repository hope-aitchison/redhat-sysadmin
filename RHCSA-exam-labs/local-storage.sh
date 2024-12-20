#!/bin/bash

## Managing MBR partition
# on primary disk, add an extended partition that uses all remaining disk space
# create a 1 GiB logical partition
# format to have a ext4 filesystem
# mount persitently using label EXTFILES on /mnt/data

mkdir -p /mnt/data

fdisk /dev/nvme1n1
n, e
# use default first and last sectors

n, 5, +1G, w

mkfs.ext4 -L EXTFILES /dev/nvme1n1p5
vim /etc/fstab
LABEL=EXTFILES        /mnt/data     ext4        defaults    0   0
mount -a
systemctl daemon-reload
reboot

lsblk -fs


## Managing GPT partitions

fdisk /dev/nvme1n1
g # to create new empty gpt partition table
n, 1, last sector +2G, w

mkfs.vfat /dev/nvme1n1p1
lsblk -o +UUID | grep nvme1n1p1 | awk '{ print $NF }' >> /etc/fstab
UUID=xxx    /mnt/files  vfat    defaults    0   0
mount -a
lsblk -fs


## Managing LVM
# creating logical volumes
# on hard disk, add a 2 GB partition to be used for creating LVM logical volumes
# create a volume group with the name "vglabs" and add your partition just created into it
# in the volume group create a logical volume with the name "lvlabs"  
# which uses half the available disk space of the logical volume
# format with the XFS filesystem

gdisk /dev/nvme1n1

n, +2G, p, w
dnf install -y lvm2

partprobe /dev/nvme1n1 # to ensure kernel registers new partition

pvcreate /dev/nvme1n1p2 # to initialise the partition as a physical volume
# this prepares it for use in a LVM configuration

vgcreate vglabs /dev/nvme1n1p2 
# creates the volume group and adds the new physical volume to it

vgs # display volume group ingo
  VG     #PV #LV #SN Attr   VSize  VFree
  vglabs   1   0   0 wz--n- <2.00g <2.00g

lvcreate -l 50%VG -n lvlabs vglabs
# create the logical volume and use 50% of the available space of the volume group

lvs # display logical volume 
  LV     VG     Attr       LSize    Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvlabs vglabs -wi-a----- 1020.00m

mkfs.xfs /dev/vglabs/lvlabs
lsblk -fs | grep lvlabs
vglabs-lvlabs xfs                        d3c6487d-9195-4429-9d20-d20a565d64c3


## Managing swap