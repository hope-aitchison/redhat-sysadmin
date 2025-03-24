#!/bin/bash

# find

man find
find - search for files in a directory hierarchy
only looks for exact matches

which
man which
which - shows the full path of (shell) commands
which passwd # shows binary location of passwd command

find / -name "hosts"
# /etc/hosts

find /etc -exec grep -l student {} \;
# looks for files in /etc that contain "student"

find /etc -exec grep -H ec2-user {} \;
# looks for files in /etc that contains ec2-user and outputs location

find /etc -exec grep -H ec2-user {} \; > files.txt
# outputs the find results to files.txt

find / -type f -size +100M
# find files only larger than 100 mb
find / -type f -size +100M -exec cp {} /big.txt \;
# find files only larger than 100 mb and copy the contents of them to /big.txt

find /etc -type f -size +10M > /big.txt
# find files only larger than 100 mb and copy the location to /big.txt

-exec cp {} # performs for each file found by find

find /etc -type f | xargs grep "ec2-user" # same command with xargs instead

find /etc/ -name '*' -type f | xargs grep "127.0.0.1"
# xargs takes stinput from find command (list of files found) and executes grep using those items as arguments

find /etc/ -name '*' -type f | xargs grep "127.0.0.1" | xargs -I {} cp {} /find/localhost
# as above and then pipes all located files as arguments 
# -I input and {} is placeholder
# xargs takes each item from the input (from the find and grep commands) and then substitutes {} with the input (the filename)

2>/dev/null
# 2 in stderr
# > redirects
# blackhole discard location

find / -name "*hosts*"
# wildcards when you do not know the exact name

find ~/. -type f -exec chmod 644 {} \; # chmod executed each time for every matching file
find ~/. -type f | xargs chmod 644 # this is much faster when lots of files found