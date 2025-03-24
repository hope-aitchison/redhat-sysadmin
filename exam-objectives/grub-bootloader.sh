#!/bin/bash

GRUB - GRand Unified Bootloader 
RHEL 9 uses GRUB 2

Kernel parameters control how the system boots

# temporary change - one time edit
# 1. interupt the GRUB menu during boot
e # edit

# 2. locate the line starting with linux

# 3. add desired parameter at the end
root=/dev/mapper/rhel-root # means kernel can access the root directory
rhgb quiet # remove this, it hides interesting boot messages

# 4. boot with modified changes
Ctrl+X

# persistent changes

/etc/default/grub

# edit the following line
GRUB_CMDLINE_LINUX
# include any extra parameters
rhgb quiet # remove this, it hides interesting boot messages

# check system type
lsblk | less
# checking to see if boot disk has efi partition
# vfat - efit

# regenerate grub configuration mbr
grub2-mkconfig -o /boot/grub2/grub.cfg

# efi
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg

# apply changes
reboot

