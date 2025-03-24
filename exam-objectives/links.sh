#!/bin/bash 

# Hard links

Creates another name for the same file on disk. Both files point to the same inode  
Changes to one affect the other.

ln file1.txt file2.txt

ls -li # to show the inodes

If the original file is deleted the hardlink still works, because the data remains
Can only point to files, not directories

# Soft (symbolic) links

Like a shortcut - points to another file but does not share the same inode.

ln -s file1.txt file2.txt

Can point to files or directories
If the original file is deleted, this breaks the soft link.