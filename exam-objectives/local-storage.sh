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

# remove a physical volume

vgs # check if it is part of a vg
vgreduce my_vg /dev/nvme1n1p1

pvremove /dev/nvme1n1p1

# create a volume group

vgcreate -s 1G -n my_vg /dev/nvme1n1p1
# size 1 G name my_vg

# add more physical volumes to an existing volume group
vgextend my_vg /dev/nvme1n1p2
# expands the volume group by adding p2

vgdisplay # display vg details

# create a logical volume

lvcreate -L 5G -n my_lv my_vg
lvcreate -l 50%VG -n my_lv my_vg

# extend a lv

lvextend -L +20 my_vg/my_lv /dev/nvme1n1p1  # extending by 20 extents
lvextend -l +50%FREE my_vg/my_lv /dev/nvme1n1p1 # extending by 20% free extents

# format and mount the lv

mkfs.xfs /dev/my_vg/my_lv
mkdir /mnt/my_lv
mount /dev/my_vg/my_lv /mnt/my_lv

# resizing filesystems

resize2fs # ext4 
xfs_growfs # xfs, cannot decrease


# to mount persistently add to /etc/fstab
/dev/my_vg/my_lv /mnt/my_lv     xfs     defaults    0   0

mount -a
findmnt --verify
systemctl daemon-reload

# delete a lv

umount /mnt/my_lv

lvchange -an /dev/my_vg/my_lv # deactivate

lvremove /dev/my_vg/my_lv

lvs # verify







