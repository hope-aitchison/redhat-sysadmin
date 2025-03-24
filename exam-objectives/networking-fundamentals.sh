#!/bin/bash 

# Network processes

sshd
httpd # need to install
NetworkManager
firewalld # need to install

# NetworkManager - primary tool for managing network configurations

systemctl status NetworkManager

# start automatically at boot
systemctl enable NetworkManager 
/etc/systemd/system/multi-user.target.wants/ # symlink created here

# config files
/etc/NetworkManager/system-connections/

nmcli # commandline tool for NetworkManager

nmcli device show
nmcli connection show

# dns configuration
/etc/resolv.conf

ip addr show # show the loopback and IP address
ip a # same thing
ip r # show routing table
nmcli d # show device status

hostnamectl set-hostname 
/etc/hostname # written to here

/etc/hosts # named servers & their ip addresses

nmtui # graphical interface for managing network connections

ss # utility to investigate sockets

ss -tunap #  display sockets with tcp, udp, ports & processes

# configuring static IPv4 Address
nmcli con mod eth0 ipv4.addresses 127.0.0.1/8
nmcli con mod eth0 ipv4.gateway 127.0.0.1
nmcli con mod eth0 ip4.dns "8.8.8.8,8.8.4.4"
nmcli con mod eth0 ip4.method manual

nmcli con up eth0

# or edit the relevant configuration file
sudo vi /etc/NetworkManager/system-connections/eth0.nmconnection
[ipv4]

# reload network manager
nmcli con reload 

# for a dynamic IP address
nmcli con mod eth0 ipv4.method auto

nmcli con show eth0 # show specific connection details

# hostname resolution

/etc/hosts # hosts file
/etc/resolv.conf # dns configuration
/etc/nsswitch.conf # name service switch

hostnamectl # check hostname
hostnamectl set-hostname # change hostname

getent # get entries

# verify DNS name resolution
getent hosts example.com
nslookup example.com
dig example.com

dig # domain information grouper
# queries dns servers directly for domain resolution 
dig -x 8.8.8.8 # reverse dns lookup

# configure local hostname
/etc/hosts
127.0.0.1   localhost
192.168.1.10    webserver.local     webserver

# configure name service switch
# determines how the system resolves queries, states the order
/etc/nsswitch.conf
hosts: files    dns     myhostname
# check /etc/hosts, then dns, then use system hostname as fallback

# flush the dns cache
systemd-resolve --flush-caches
