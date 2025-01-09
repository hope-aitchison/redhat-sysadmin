#!/bin/bash

## Managing user accounts and groups
# Create users sarah and zeina
# Make the members of the group staff as a secondary group
# Create users bob and bilal
# Make the members of the group visitors as a secondary group
# Set pw expiration for these users to 90 days
# Do not change standard pw expiration

groupadd staff
groupadd visitors

useradd sarah -G staff
useradd zeina -G staff
useradd bob -G visitors
useradd bilal -G visitors

chage -M 90 sarah
chage -M 90 zeina
chage -M 90 bob
chage -M 90 bilal

chage -l sarah...
vim /etc/shadow # to confirm


## Managing passwords

## Configuring superuser access

