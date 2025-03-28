#!/bin/bash

tar # tape archiver
gzip / gunzip # compression
bzip2 / bunzip2 # better compression

tar -cvf my_archive.tar /home /etc
# c create
# v verbose
# f filename to be created

tar -tvf my_archive.tar
# t lists contents

# extracting contents
tar -xvf my_archive.tar
# x extracts

gunzip file.txt.gz
bunzip2 file.txt.bz

# least compressed
tar -cvf /tmp/my_archive.tar /home /etc
tar -czvf /tmp/my_archive.tgz /home /etc # gzip
tar -cjvf /tmp/my_archive.bz2 /home /etc # bzip2
tar -cJvf /tmp/my_archive.xz /home /etc # xz
# most compressed

## example 

# create archive file of /opt and /etc in /home directory
# create a sym link to this archive file in /tmp

tar -cvf /home/example.tar /opt /etc
cd /tmp
ln -s /home/example.tar /tmp/example.tar
ls -la # shows new link 

