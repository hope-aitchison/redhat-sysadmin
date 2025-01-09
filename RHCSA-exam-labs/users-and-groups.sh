#!/bin/bash

## Managing user accounts and groups
# Create users sarah and zeina
# Make the members of the group staff as a secondary group
# Create users bob and bilal
# Make the members of the group visitors as a secondary group
# Set pw expiration for these users to 90 days
# Do not change standard pw expiration

groupadd staff
groupadd visitors

useradd sarah -G staff
useradd zeina -G staff
useradd bob -G visitors
useradd bilal -G visitors

chage -M 90 sarah
chage -M 90 zeina
chage -M 90 bob
chage -M 90 bilal

chage -l sarah...
vim /etc/shadow # to confirm

## Managing passwords
# Disable login for user "sarah" without deleting the user account
# Set user account "bob" to expire on Jan 1st 2032
# Ensure that the default password hashing algorithm for new users is set to "SHA256"
# Enforce a maximum password validity of 120 days for new users

usermod -s /sbin/nologin sarah
grep sarah /etc/passwd
sarah:x:1002:1004::/home/sarah:/sbin/nologin

passwd -L sarah # this locks the password

su sarah
This account is currently not available.

usermod -e 2032-01-01 bob
chage -l bob
...
Account expires						: Jan 01, 2032
grep bob /etc/shadow
bob:!!:20097:0:90:7::22645: 

vim /etc/login.defs # default login settings
...
PASS_MAX_DAYS   120
...
ENCRYPT_METHOD SHA256

## Configuring superuser access
# Configure user "sarah" so that she can perform any tasks using elevated sudo privileges
# Configure user "zeina" so that she can manage user passwords but not for user root

usermod -aG wheel sarah
# important to append in order to not overwrite previous group assignment

id sarah
uid=1002(sarah) gid=1004(sarah) groups=1004(sarah),10(wheel),1002(staff)

readlink -f $(which passwd) # find the path to the command binary
/usr/bin/passwd

type passwd
passwd is hashed (/bin/passwd) # link location and not visible

visudo

zeina ALL=/usr/bin/passwd, ! /usr/bin/passwd

# testing steps
sudo -i
passwd zeina # choose password

su - zeina
sudo passwd root
# enter zeina password
Sorry, user zeina is not allowed to execute '/bin/passwd root' //
as root on ip-10-0-101-240.eu-west-2.compute.internal.

sudo passwd bob
# works!

# recommended in exam to revert back any tests done

passwd -d zeina
passwd -d bob

