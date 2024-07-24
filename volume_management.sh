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

mkfs.xfs -L myxfs /dev/device # adds a custom label

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
lsblk -f | grep "nvme1n1p1" | awk '{ print $3 }'>> /etc/fstab

#######################################
## SWAP
# When the physical RAM is fully utilized
# OS can move some inactive pages of memory to the swap space
# This process frees up RAM for other active processes

fdisk /dev/nvme1n1
n   2(default)  empty (default)    +2   P
m   x (expert)  m   f (fix order)   r (return)  p   w 

lsblk
fdisk -l /dev/nvme

free -m # check memory, 0 swap

mkswap /dev/nvme1n1p2
free -m # now 2047
swapon /dev/nvme1n1p2

blkid | grep nvme1n1p2 | awk '{ print $2 }' >> /etc/fstab
UUID    none    swap    defaults    0   0

mount -a
findmnt --verify
systemctl daemon-reload

# extended partitions use all remaining disk space by default
# then move on to logical paritions (no. 5 first)

#######################################
## LVM
# logical volumes

VG # volume group
PV # physical volume

# allows you to add more space from the volume group when needed
/dev/vgx/lvx

pvcreate /dev/nvme1n1p1 # create the physical volume on the partition
vgcreate vgdata /dev/nvme1n1p1 # create the volume group
vgcreate -s 8M vgdata /dev/nvme1n1p1 # create the volume group & define extent size 
lvcreate -n lvdata -L 1G vgdata # create the logical volume on the new vg
mkfs /dev/vgdata/lvdata # create the fs

vgdisplay # show properties

# extents are used to allocate space from the PV in a VG
# extent size defined when creating the VG
# default size 4MB

dnf install -y lvm2

# gdisk for when more than 4 partitions needed - do not mix on the same device with fdisk
# first create the partition
gdisk /dev/nvme1n1
? # show help
n   1   +2G L   lvm     8e00    p   w   Y

lsblk # verify 2G partition now exists

pvcreate /dev/nvme1n1p1
vgcreate -s 8M vgdata /dev/nvme1n1p1
vgdisplay
lvcreate -L 1G -n lvdata /dev/vgdata
vgdisplay
lvs # show logical volumes

mkfs.vfat /dev/vgdata/lvdata # note the new filestructure
lsblk -f

nvme1n1
└─nvme1n1p1       LVM2_member LVM2 001       dpteKH-1y3D-uThc-83an-Os3D-Oqff-4cXYE3
  └─vgdata-lvdata vfat        FAT32          3EF3-5F52

mkdir /lvdata
vim /etc/fstab
/dev/vgdata/lvdata  /lvdata     vfat        defaults    0   0

mount -a
findmnt --verify
systemctl daemon-reload

#advisable to reboot

expr SUM # for basic calculations
1 GB = 1024 MB
1 MB = 1024 KB
1 KB = 1024 B

# resizing

vgs # verify remaining space
vgextend PV VG # add a PV to the VG
lvextend -L +20 vgdata/lvdata /dev/nvme1n1p1 # extending the size of the LV by 20 extents
man lvextend # for examples

resize2fs # ext4 
xfs_growfs # xfs, cannot decrease

#######################################
## returning to blank disk

umount /dev/vgdata/lvdata /lvdata

lvchange -an /dev/vgdata/lvdata # deactivate

lvremove /dev/vgdata/lvdata

vgremove vgdata

pvremove /dev/nvme1n1p1

gdisk /dev/nvme1n1
# delete and write

systemctl daemon-reload

lsblk


#######################################
## EXAMPLE Q
# create two partitions, size 1 GB each, lvm partition type

lsblk

fdisk /dev/nvme1n1
n +1G t lvm (x2) w  

lsblk 
nvme1n1     259:5    0   10G  0 disk
├─nvme1n1p1 259:6    0    1G  0 part
└─nvme1n1p2 259:7    0    1G  0 part

vgcreate vgfiles /dev/nvme1n1p1 # create PV and VG in one command
  Physical volume "/dev/nvme1n1p1" successfully created.
  Volume group "vgfiles" successfully created

vgs
  VG      #PV #LV #SN Attr   VSize    VFree
  vgfiles   1   0   0 wz--n- 1020.00m 1020.00m

expr 1024 / 4
256 # 1GB each default extent is 4M

lvcreate -l 255 -n lvfiles /dev/vgfiles # 1MB set aside for metadata

lsblk
nvme1n1             259:5    0   10G  0 disk
├─nvme1n1p1         259:6    0    1G  0 part
│ └─vgfiles-lvfiles 253:0    0 1020M  0 lvm
└─nvme1n1p2         259:7    0    1G  0 part

mkfs.ext4 /dev/vgfiles/lvfiles
mount /dev/vgfiles/lvfiles /mnt

vgs
  VG      #PV #LV #SN Attr   VSize    VFree
  vgfiles   1   1   0 wz--n- 1020.00m    0 # nothing left in this PV and VG!

vgextend vgfiles /dev/nvme1n1p2 # add the second partition to the VG
  Physical volume "/dev/nvme1n1p2" successfully created.
  Volume group "vgfiles" successfully extended

vgs
  VG      #PV #LV #SN Attr   VSize VFree
  vgfiles   2   1   0 wz--n- 1.99g 1020.00m 

lvextend -r -l +50%FREE /dev/vgfiles/lvfiles # add half the free extents from second partition
  Size of logical volume vgfiles/lvfiles changed from 1020.00 MiB (255 extents) to <1.50 GiB (383 extents).
  File system ext4 found on vgfiles/lvfiles mounted at /mnt.
  Extending file system ext4 to <1.50 GiB (1606418432 bytes) on vgfiles/lvfiles...

vgs
  VG      #PV #LV #SN Attr   VSize VFree
  vgfiles   2   1   0 wz--n- 1.99g 508.00m

lvdisplay
...
  LV Size                <1.50 GiB
  Current LE             383

expr 383 - 255
128

lsblk
nvme1n1             259:5    0   10G  0 disk
├─nvme1n1p1         259:6    0    1G  0 part
│ └─vgfiles-lvfiles 253:0    0  1.5G  0 lvm  /mnt
└─nvme1n1p2         259:7    0    1G  0 part
  └─vgfiles-lvfiles 253:0    0  1.5G  0 lvm  /mnt

