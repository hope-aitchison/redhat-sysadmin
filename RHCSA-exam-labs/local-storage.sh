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
# Create a GPT partition with size 2G on hard disk
# Format this partition with vfat filesystem
# mount this partition on /mnt/files using its UUID

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

fdisk /dev/nvme1n1

n, +2G, t, 2 (partition number), lvm, p, w
dnf install -y lvm2

partprobe /dev/nvme1n1 # to ensure kernel registers new partition

pvcreate /dev/nvme1n1p2 # to initialise the partition as a physical volume
# this prepares it for use in a LVM configuration
# vgcreate triggers this part for you

vgcreate vglabs /dev/nvme1n1p2 
# creates the volume group and adds the new physical volume to it

vgs # display volume group ingo
  VG     #PV #LV #SN Attr   VSize  VFree
  vglabs   1   0   0 wz--n- <2.00g <2.00g

lvcreate -l 50%VG -n lvlabs vglabs
lvcreate -l 50%FREE -n lvlabs vglabs
# create the logical volume and use 50% of the available space of the volume group

lvs # display logical volume 
  LV     VG     Attr       LSize    Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvlabs vglabs -wi-a----- 1020.00m

mkfs.xfs /dev/vglabs/lvlabs
lsblk -fs | grep lvlabs
vglabs-lvlabs xfs                        d3c6487d-9195-4429-9d20-d20a565d64c3

# you can verify all working as expected by mounting on the temporary /mnt directory
mount /dev/vglabs/lvlabs /mnt
umount /mnt

## Managing swap
# create a 1 GB swap file called /swapfile
# mount this swap file persistently

dd # convert and copy a file

dd if=/dev/zero of=/swapfile bs=1M count=1024

/dev/zero # special file that provides an endless stream of null (zero) bytes
# does not contain real data but provides an endless stream of zeros
# a swap file must contain initialised data before being formatted with mkswap

mkswap /swapfile
chmod 0600 /swapfile


vim /etc/fstab
/swapfile   none  swap  defaults  0 0

free -m
swapon -a
swapon --show
NAME      TYPE  SIZE USED PRIO
/swapfile file 1024M 512K   -2
free -m
                total        used        free      shared  buff/cache   available
Mem:             709         355          56           2         401         354
Swap:           1023           0        1023
