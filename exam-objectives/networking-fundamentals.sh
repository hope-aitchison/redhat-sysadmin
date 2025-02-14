#!/bin/bash 

# Network processes

sshd
httpd # need to install
NetworkManager
firewalld # need to install

# NetworkManager - primary tool for managing network configurations

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



