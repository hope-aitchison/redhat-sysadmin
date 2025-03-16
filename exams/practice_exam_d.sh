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

mkdir /mydata

fdisk /dev/nvem1n1

lsblk 

mkfs.ext4 -L mydata /dev/nvme1n1p1

vim /etc/fstab
LABEL=mydata    /mydata     ext4    defaults    0   0

mount -a
lsblk -f

# Set default values for new users. A user should get a warning three days before expiration of the current password. 
# Also, new passwords should have a maximum lifetime of 120 days.

vim /etc/login.defs

useradd testuser
chage -l testuser

#  Create users lori and laura and make them members of the secondary group sales. Ensure that user lori uses UID 2000 and user laura uses UID 2001.

groupadd sales

useradd -u 2000 -G sales lori
useradd -u 2001 -G sales laura

cat /etc/passwd

cat /etc/passwd | grep sales

# Create shared group directories /groups/sales and /groups/data, and make sure the groups meet the following requirements:
# * Members of the group sales have full access to their directory.
# * Members of the group data have full access to their directory.
# * Others has no access to any of the directories.
# * Alex is general manager, so user alex has read access to all files in both directories and has permissions to delete 
# all files that are created in both directories.

mkdir -p /groups/{sales,data}

cd /groups

groupadd data

chown :sales sales
chown :data data

useradd alex

usermod -aG data,sales alex

chmod 2770 data # means group members have full access to their directory
chmod 2770 sales


#  Create a 1-GiB swap partition and mount it persistently.

lsblk

fdisk /dev/nvme1n1

mkswap /dev/nvme1n1p2

swapon /dev/nvme1n1p2

lsblk -o UUID /dev/nvme1n1p2 >> /etc/fstab
UUID=xxx    none    swap    defaults    0   0

mount -a
systemctl daemon-reload

#  Find all files that have the SUID permission set, and write the result to the file /root/suidfiles.

man find # examples

find / -type f -perm -4000 >> /root/suidfiles

# Create a 1-GiB LVM volume group. In this volume group, create a 512-MiB swap volume and mount it persistently.



# Add a 10-GiB disk to your virtual machine. On this disk, create a Stratis pool and volume. 
# Use the name stratisvol for the volume, and mount it persistently on the directory /stratis.

dnf install -y stratisd
dnf install -y stratis-cli

lsblk

stratis pool create mypool /dev/nvme1n1

mkdir /stratis

stratis filesystem create mypool stratisvol

stratis filesystem list

lsblk -o UUID /dev/stratis/mypool/stratisvol >> /etc/fstab

UUID=xxx    /stratis    xfs     defaults,x-systemd.requires=stratisd.service    0   0

mount -a

systemctl daemon-reload


#  Install an HTTP web server and configure it to listen on port 8080.

dnf install -y httpd

systemctl start httpd

vim /etc/httpd/conf

Listen=8080

cd /var/www/html
vim index.html
hello world

man semanage port

semanage port -m -t http_port_t -p tcp 8080

semanage port -l | grep http

systemctl daemon-reload
systemctl restart httpd

curl localhost:8080
hello world

journalctl -xe | grep httpd
ss -tlnp | grep httpd


#  Create a configuration that allows user laura to run all administrative commands using sudo.

cd /etc/sudoers.d/
vim laura-user
laura ALL=(ALL)  ALL

# or

visudo

# verify
su - laura
sudo whoami
root

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