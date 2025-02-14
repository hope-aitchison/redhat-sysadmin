#!/bin/bash

## firewalld & NFS

dnf install -y firewalld

sudo firewall-cmd --state
systemctl start firewalld
sudo firewall-cmd --reload

## example http
firewall-cmd --list-all
firewall-cmd --get-services 
firewall-cmd --get-services | grep http
firewall-cmd --add service http --permanent
firewall-cmd --reload

# for loop firewall command for nfs networking
sudo -i
for x in rpc-bind mountd nfs; do firewall-cmd --add-service $x --permanent; done
sudo firewall-cmd --reload
sudo firewall-cmd --list-services

# block a specific port
firewall-cmd --remove-port=22/tcp --permanent
firewall-cmd --reload

# restrict access to service
firewall-cmd --remove-service=http --permanent
firewall-cmd --reload

# query a port
firewall-cmd --query-port=22/tcp

# networking tools
ip a
inet # localhost IP
eth0 # public IP