#!/bin/bash

# superuser access managed by the root account

su - # switch to root user
sudo -i # switch to root shell

# give a user admin privileges
usermod -aG wheel hope

# wheel group users can execute commands with sudo

groups hope # verify

# sudo permissions
/etc/sudoers
visudo # edit this file

# add custom user permissions to bottom of the file

# grant full root access to a user
hope ALL=(ALL) ALL
# hope can now run any commands by prefixing with sudo
ALL - rule applies to all hosts, ignored on standalone system
(ALL) - user can run commands as any target user
ALL - user can run any command with sudo

# specific commands granted to a user
bart ALL=(ALL) /sbin/shutdown, /sbin/reboot
# bart can run shutdown and reboot

# grant passwordless sudo access
hope ALL=(ALL) NOPASSWORD: ALL

# allow user bart to have sudo access to change passwords but not for root
bart ALL=/usr/sbin/passwd, ! /usr/sbin/passwd root

# add a default that makes all sudo users only enter their password every 60 seconds
Defaults timestap_type=global , timestamp_timeout=60


# restricting root login for ssh

/etc/ssh/sshd_config 
PermitRootLogin no

systemctl restart sshd


