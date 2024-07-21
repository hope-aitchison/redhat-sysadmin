#!/bin/bash

##################################
## kickstart file example

url --url="http://myserver/.."  # URL to access the installation media
repo --name="myrepo" --baseurl=http://myrepo.url  # Base URL to access repositories

text  # Forces text mode installation, no GUI
vnc --password=password  # Enables the VNC viewer for remote access to the installation

clearpart --all --drives=sda,sdb  # Removes all partitions on specified drives

# Create partitions automatically
part /home --fstype=ext4 --label=home --size=2048 --maxsize=4096 --grow  # Creates and mounts /home
autopart  # Automatically creates root, swap, and boot partitions

network --device=ens33 --bootproto=dhcp  # Configures the primary network interface for DHCP
firewall --enabled --service=ssh,http  # Opens the firewall and ports for SSH and HTTP
timesource --ntp-server=pool.ntp.org  # Sets up NTP
rootpw --plaintext secret  # Configures plain text root password
selinux --enforcing  # Activates SELinux

# validate syntax
dnf install -y pykickstart

ksvalidator --version RHEL9 my-kickstart.ks

##################################
## KVMs

grep -E "svm|vmx" /proc/cpuinfo
# if returns result the server can virtualise

## Examples and doc locations for anaconda installer files
/usr/share/doc/anaconda/examples
/root/anaconda-ks.cfg