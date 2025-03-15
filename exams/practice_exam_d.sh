# Configure your system to automatically mount the ISO of the installation disk on the directory /repo. Configure your system to remove this 
# loop-mounted ISO as the only repository that is used for installation. Do not register your system with subscription-manager, and remove all 
# references to external repositories that may already exist.

lsblk 

/dev/sd0

mkdir /repo

dd if=/dev/sd0 of=/repo/rhel9.iso bs=1M status=progress

vim /etc/fstab
/repo/rhel.iso      /repo   iso9660     loop        0   0

dnf config-manager --add-service=file:///repo/BaseOS
dnf config-manager --add-service=file:///repo/AppStream

cd /etc/yum/repos.d/

rm all other .repo files

dnf config-list # to confirm

dnf install -y vim

# Create a 500-MiB partition on your second hard disk, and format it with the Ext4 file system. Mount it persistently on the directory /mydata, 
# using the label mydata.



# Set default values for new users. A user should get a warning three days before expiration of the current password. 
# Also, new passwords should have a maximum lifetime of 120 days.


/etc/security/pwquality

#  Create users lori and laura and make them members of the secondary group sales. Ensure that user lori uses UID 2000 and user laura uses UID 2001.


# Create shared group directories /groups/sales and /groups/data, and make sure the groups meet the following requirements:
# * Members of the group sales have full access to their directory.
# * Members of the group data have full access to their directory.
# * Others has no access to any of the directories.
# * Alex is general manager, so user alex has read access to all files in both directories and has permissions to delete 
# all files that are created in both directories.


#  Create a 1-GiB swap partition and mount it persistently.


#  Find all files that have the SUID permission set, and write the result to the file /root/suidfiles.


# Create a 1-GiB LVM volume group. In this volume group, create a 512-MiB swap volume and mount it persistently.


# Add a 10-GiB disk to your virtual machine. On this disk, create a Stratis pool and volume. 
#  Use the name stratisvol for the volume, and mount it persistently on the directory /stratis.



#  Install an HTTP web server and configure it to listen on port 8080.


#  Create a configuration that allows user laura to run all administrative commands using sudo.


#  Create a directory with the name /users and ensure it contains the subdirectories linda and anna. 
#  Export this directory by using an NFS server.

mkdir -p /users/{anna,linda}

dnf install nfs-utils

systemctl start nfs-server

vim /etc/export
/users      *(rw,no_root_squash)

exportfs -r
exportfs -v

showmount -e

#  Create users linda and anna and set their home directories to /home/users/linda and /home/users/anna. 
#  Make sure that while these users access their home directory, autofs is used to mount the NFS shares 
#  /users/linda and /users/anna from the same server.

dnf install -y autofs

useradd -d /home/users/anna anna
useradd -d /home/users/linda linda


cd /etc
vim auto.master

/home/users     auto.users

vim auto.users
anna        -rw     localhost:/users/anna
linda       -rw     localhost:/users/linda

systemctl start autofs

cd /home/users
# empty!
cd linda
# works!

# verify
mount 
/etc/auto.users on /home/users type autofs (rw,relatime,fd=10,pgrp=16174,timeout=300,minproto=5,maxproto=5,indirect,pipe_ino=47434)
-hosts on /net type autofs (rw,relatime,fd=13,pgrp=16174,timeout=300,minproto=5,maxproto=5,indirect,pipe_ino=47436)
/dev/nvme0n1p4 on /home/users/linda type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
/dev/nvme0n1p4 on /home/users/anna type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)

lsblk
nvme0n1     259:0    0   20G  0 disk
├─nvme0n1p1 259:1    0    1M  0 part
├─nvme0n1p2 259:2    0  200M  0 part /boot/efi
├─nvme0n1p3 259:3    0  600M  0 part /boot
└─nvme0n1p4 259:4    0 19.2G  0 part /home/users/anna
                                     /home/users/linda
                                     /
nvme1n1     259:5    0   10G  0 disk