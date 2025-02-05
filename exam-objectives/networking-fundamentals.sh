#!/bin/bash 

# Network processes

sshd
httpd # need to install
NetworkManager
firewalld # need to install

nmcli # commandline tool for NetworkManager

nmcli device show
nmcli connection show

# dns configuration
/etc/resolv.conf

ip addr show # show the loopback and IP address
ip a # same thing

hostnamectl set-hostname 
/etc/hostname # written to here

/etc/hosts # named servers & their ip addresses

nmtui # graphical interface for managing network connections

ss # utility to investigate sockets

ss -tunap #  display sockets with tcp, udp, ports & processes





