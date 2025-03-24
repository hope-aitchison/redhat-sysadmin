#!/bin/bash

# FHS filesystem hierarchy standard

/etc # config
/usr # binaries
/sbin # su binaries
/bin # binaries
/var # temporary files and directories
/var/log # journald (element of systemd) logs
/tmp # temporary files for any user

man file-hierarchy