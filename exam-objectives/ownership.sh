#!/bin/bash

# Set-GID
# group ID

chown :devteam /shared/devteam

chmod 2775 /shared/devteam
# 2 - set GID-Bit, new files/folders inherit the group

ls -ld /shared/devteam
drwxrwsr-x 2 root devteam
# s confirms

touch /shared/devteam/file
ls -l /shared/devteam/file
-rw-r--r-- 1 root devteam

# Sticky bit
# restricts file deletion in shared folders
chmod +t /data/sales
# ensures files can only be deleted by the user who made the file
chmod 1777 /data/sales # alternative

# user accounts

useradd hope
useradd -s /bin/bash # user with bash shell default

usermod
usermod -d /new/home/path hope
usermod -l newname bart
usermod -L bart # lock their account

userdel bart
userdel -r bart # delete and remove home directory

# see all local users
cat /etc/passwd

id hope # check user exists

awk -F: '$3 < 1000' /etc/passwd # see all system users

# user groups
# all users are assigned a primary group by default

usermod -aG wheel hope # add a user to an additional group
gpasswd -d bart wheel # remove user from a group

# passwords

passwd hope

passwd --expire bart # force bart to change password on next login

chage -l hope # check user's password aging settings

chage -M 90 hope # max password age set to 90 days
chage -M -1 hope # disable password expiration

chage -W 7 bart # set a warning period before expiration

passwd -l bart # locks, does not disable user
usermod --expiredata 1 bart # disable user immediately 

# global password config
/etc/login.defs

# stronger password policies
/etc/security/pwquality.conf

# groups

groupadd developers
groupadd -g 2025 developers

groupdel developers # no users assigned to group before deletion

usermod -aG developers bart
# -aG adds without removing from any other groups

groups bart # verify

gpasswd -d bart developers # remove user from group

usermod -g admins bart # change users primary group
id bart # check primary group

groupmod -g 2025 developers # change group id

groupmod -n developers devops # change group name

cat /etc/group # view all groups on system
getent group devops # group details

pgasswd -A hope devops # assign admin to group
# admin can add and remove users from group

