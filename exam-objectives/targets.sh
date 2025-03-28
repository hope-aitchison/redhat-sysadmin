#!/bin/bash

# targets

systemctl list-units --type=targets

rescue.target - single-user mode, maintanence mode, minimal
multi-user.target - multi-user mode,no GUI
graphical.target - mulit-user, GUI
reboot.target - reboots the system
poweroff.target - shuts down system
emergency.target - bare minumum, shell only

# to see available target files
ls /usr/lib/systemd/system/

# change targets whilst system running - no reboot

systemctl isolate rescue.target

# set default

systemctl get-default
systemctl set-default multi-user.target

# changing targets from GRUB menu

Reboot and hold shift / ESC to enter GRUB menu
Select kernel entry and e to edit
Find the line that starts with linux/vm-linuz-...
At the end of this line add the target of choice
systemd.unit=multi-user.target

crtl+X to reboot with this new target
This is a temporary change and only affects the current boot

systemctl rescue # keeps root filesystem mounted
systemctl emergency # minimal shell with almost nothing running

# reset lost root password

Reboot and hold shift / ESC to enter GRUB menu
Select kernel entry and e to edit

linux /vmlinuz-... rw init=/bin/bash
Ctrl X # boots into root shell with modified parameters\
mount -o remount,rw /
passwd # reset the root password
touch /.autorelabel # SElinux labelling
exec /usr/liv/systemd/system # reboot from this shell
# can also reboot using vm software

# persistently enable grub boot messages
/etc/default/grub
remove rhdb and quiet 
