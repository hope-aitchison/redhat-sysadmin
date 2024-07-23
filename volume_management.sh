#!/bin/bash

# lsblk reads kernel partition table in /proc/partitions
lsblk
lsblk -f
fdisk -l
fdisk -l /dev/nvme1n1 # partioning on a device

MBR = master boot record
- 512 bytes to store boot info
- 64 bytes for partitions
- 4 partitions, at max 2 TiB 
- for more partitions, extended and logical partitions must be used
GPT = GUID partition table
- global UID partition table
- offers more space for partitions
- overcomes MBR limits
- 128 partitions max
- this is the standard these days

fdisk /dev/disk # enter partition editing mode
n, 1 (default), empty (default), +1G (any size), p, w
# to add a new partition against a disk of size 1G

# create a filesystem
mkfs.ext4 or mkfs.vfat or mkfs.xfs /dev/device

# mount a fs (specific order)
mount /dev/device /mnt
umount /dev/device /mnt

# list directory structure
findmnt

# show real filesystems only
mount | grep '^/'

# persistent mounting
/etc/fstab

UUID    fs      /mount      defaults    0   0

mount -a # mount all
findmnt --verify # check syntax
systemctl daemon-reload # manages mounting

blkid # prints UUIDs
blkid | grep /nvme1n1 | awk '{ print $2 }' # extract the UUID
blkid | grep /nvme1n1 | awk '{ print $2 }' >> /etc/fstab