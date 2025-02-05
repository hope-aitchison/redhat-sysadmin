#!/bin/bash 

# List, create, delete partitions on MBR and GPT disks

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

# lsblk reads kernel partition table in /proc/partitions
lsblk
lsblk -f # include filesystems

fdisk -l # list partitions on MBR devices
fdisk -l /dev/nvme1n1 # partioning on a device

gdisk # for GPT devices, when more than 4 partitions required

parted # for GPT or MBR, use for resizing partitions 

fdisk /dev/device # enter partition editing mode
n, 1 (default), empty (default), +1G (any size), p, w
# to add a new partition against a disk of size 1G

gdisk /dev/nvme1n1
? # show help
n   1   +2G L   lvm     8e00    p   w   Y

# create a filesystem
mkfs.ext4 /dev/device
mkfs.vfat /dev/device
mkfs.xfs /dev/device

mkfs.xfs -L myxfs /dev/device # adds a custom label

# physical volumes on partitions

dnf install -y lvm2 

# create a physical volume

pvcreate /dev/nvme1n1p1
pvs # verify
pvdisplay

# create a volume group

vgcreate -s 1G -n vgname /dev/nvme1n1p1
# size 1 G name vgname

# remove a physical volume

vgs # check if it is part of a vg
vgreduce vgname /dev/nvme1n1p1

pvremove /dev/nvme1n1p1

