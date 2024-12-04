#!/bin/bash

### Configuring remote repository access

## Configure your system such that it can use the repository https://repository.example.com
## Ensure that no GPG checks will be done while accessing this repository
## Ensure that the client will not actually use this repository
## To verify work, the repository should not show while using the dnf repolist command, but its configuration should exist

sudo dnf config-manager --add-repo https://repository.example.com

cd /etc/yu.repos.d/
vim example.repo
[repository.example.com]
name=created by dnf config-manager from https://repository.example.com
baseurl=https://repository.example.com
enabled=0 # ensures client will not use repository
gpgcheck=0


### Configuring local repository access

## Make an ISO file of your installation disk and store it as /rhel.iso
## Mount it persistently on the directory /repo on your local server
## Configure the local server to access this mounted disk as a repository
## Verify that you can install packages from this repository

dd if=/dev/sr0 of=rhel9.iso bs=1M # if input file of output file
mkdir /repo
vim /etc/fstab
/rhel9.iso       /repo   iso9660     defaults        0       0
mount -a
ls /repo # shows contents of installation disk

dnf config-manager --add-repo file:///repo/BaseOS
dnf config-manager --add-repo file:///repo/AppStream

cd /etc/yum.repos.d/
vim repo_BaseOS.repo
gpgcheck=0 # otherwise installation of anything from this repo not permitted

vim repo_AppStream.repo
gpgcheck=0 

dnf install -y git # verifies that we can now install packages from 

### Managing permissions

## make a directory /data/profs
## create a group profs
## create a user linda and add to the group profs
## configure permissions so that linda can not read or write files in /data/profs
## allow linda ability to changes permissions on /data/profs directory
## members of profs should be allowed to read and write in /data/profs
## no one else should have access to the directory

mkdir /data/profs
ls -ld /data/profs

groupadd profs
cat /etc/groups | grep profs

useradd linda -G profs
linda id

chown linda:profs /data/profs
chmod 070 /data/profs


### Finding files