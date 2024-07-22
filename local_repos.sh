#!/bin/bash

rpm -qa # all installed packages

rpm -qf /bin/ls # core-utils package installed
# the essentials package

rpm -ql coreutils | grep bin # shows the binaries within this package

rpm -ql coreutils | grep bin | wc # shows how many (wordcount)

#######################################
## Repository Access

man dnf config-manager
dnf config-manager --help

# accessible through subscription manager
dnf config-manager --enable NAME-OF-REPO

# manually configure
dnf config-manager --add-repo=NAME-OF-REPO

dnf config-manager --add-repo="file:///repo/AppStream"
dnf config-manager --add-repo="file:///repo/BaseOS"

dnf clean all # clear out the cache

# if dnf config-manager does not work

mkdir -p /repo/AppStream
mkdir -p /repo/BaseOS

createrepo /repo/AppStream
createrepo /repo/BaseOS

cd /etc/yum.repos.d
vim AppStream.repo
[AppStream]
name=AppStream
baseurl=file:///repo/AppStream
enabled=1
gpgcheck=0 # this set to 1 can cause issues in downloading packages

cp AppStream.repo BaseOS.repo # update the name, baseurl

dnf repolist # check which repos are available locally

dnf install -y nmap # check all working as expected

dnf search all seinfo # deep search for a package
