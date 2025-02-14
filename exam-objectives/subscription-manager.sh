#!/bin/bash

# red hat network

subscription-manager status
subscription-manager register --username=hopeaitchison --password=PASSWORD

# attach a subscription
subscription-manager attach --auto

# enable repos
subscription-manager repos --enable=repo-name

# install package
dnf install package-name

# install package from remote repo
# by default RHEL 9 fetches packages from enabled repositories

# list enable repos
dnf repolist

dnf search package-name
dnf search nginx

dnf install package-name

# check package details
dnf info package-name

# check installed packages
dnf list installed 

# update packages
dnf update package-name

# remove package
dnf remove package-name

# managing repositories

dnf config-manager --enable repo-name
dnf config-manager --disable repo-name

