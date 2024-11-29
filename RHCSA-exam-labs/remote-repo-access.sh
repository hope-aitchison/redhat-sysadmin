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

### Managing permissions

### Finding files