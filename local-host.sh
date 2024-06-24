#!/bin/bash

# localhost IP & alias
cat /etc/hosts

cd ~/.ssh/
ssh-keygen -t rsa -b 4096 

# check the filepath for keys
sudo cat /etc/ssh/sshd_config | grep keys
# AuthorizedKeysFile	.ssh/authorized_keys

cat id_rsa.pub >> ~/.ssh/authorized_keys

# set correct access permissions
chmod 700 ~/.ssh/
chmod 600 ~/.ssh/authorized_keys

systemctl status sshd
ssh user@localhost

# ssh logs
tail -f /var/log/secure
