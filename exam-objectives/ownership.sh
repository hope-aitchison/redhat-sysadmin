#!/bin/bash

# Set-GID
# group ID

chown :devteam /shared/devteam

chmod 2775 /shared/devteam
# 2 - set GID-Bit, new files/folders inherit the group

ls -ld /shared/devteam
drwxrwsr-x 2 root devteam
# s confirms

touch /shared/devteam/file
ls -l /shared/devteam/file
-rw-r--r-- 1 root devteam

# Sticky bit
# restricts file deletion in shared folders
chmod +t /data/sales
# ensures files can only be deleted by the user who made the file
chmod 1777 /data/sales # alternative