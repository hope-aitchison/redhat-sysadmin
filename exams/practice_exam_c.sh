# Configure your system to automatically mount the ISO of the installation disk on the directory /repo. 
# Configure your system to remove this loop-mounted ISO as the only repository that is used for 
# installation. Do not register your system with subscription-manager, and remove all references to 
# external repositories that may already exist.

lsblk -f
sudo -i

mkdir /repo

dd if=/dev/sd0 of=/repo/rhel9.iso bs=1M status=progress

vim /etc/fstab

/repo/rhel9.iso     /repo   iso9660    loop    0   0

mount -a 

ls /repo
dnf config-manager --add-repo=file:///repo/AppStream
dnf config-manager --add-repo=file:///repo/BaseOS

cd /etc/yum.repos.d
# check files are present and enabled=1

# set all other repo configs to 
enabled=0

dnf repolist # check which are available

dnf install -y vim # to confirm

# Reboot your server. Assume that you don’t know the root password, and use the appropriate mode 
# to enter a root shell that doesn’t require a password. Set the root password to mypassword.

sudo -i
reboot

# hit shift or esc multiple times on rebooting
# hit e when cursor over the grub menu

# edit the line starting with linux to contain at the end
init=/bin/bash 
# ctrl X

mount -o remount,rw /

passwd
mypassword
mypassword

touch .autorelabel

exec /usr/lib/systemd/systemd

# login as root

# Set default values for new users. Make sure that any new user password has a length of at least 
# six characters and must be used for at least three days before it can be reset.

sudo -i

/etc/login.defs

# Create users linda and anna and make them members of the group sales as a secondary group membership. 
# Also, create users serene and alex and make them members of the group account as a secondary group.

groupadd membership
groupadd account

useradd -G membership anna linda
useradd -G account serene alex

#  Configure an SSH server that meets the following requirements:
#  User root is allowed to connect through SSH.
#  The server offers services on port 2022.

dnf install -y sshd

systemctl enable --now sshd

cd /etc/ssh/config

#  Create a 4-GiB volume group, using a physical extent size of 2 MiB. In this volume group, 
#  create a 1-GiB logical volume with the name myfiles, format it with the Ext3 file system, 
#  and mount it persistently on /myfiles.

First make a partition
fdisk 

Make a physical volume

pvcreate 

Make the vg

vgcreate myvg

lvcreate myfiles

mkfs.ext3 

lsblk -o +UUID
vim /etc/fstab
/dev/myvg/mylv      /myfiles    ext3    defaults    0   0


#  Create a group sysadmins. Make users linda and anna members of this group and ensure that all 
#  members of this group can run all administrative commands using sudo.

groupadd sysadmins

groupmod -A linda sysadmins

cd /etc/sudoers.d/

#  Optimize your server with the appropriate profile that optimizes throughput.
tuned-adm 

#  Add a new disk to your virtual machine with a size of 10 GiB. On this disk, create a LVM logical volume
#  with a size of 5 GiB, configure it as swap, and mount it persistently.

Add disk through UI


#  Create a directory /users/ and in this directory create the directories user1 through user5 
#  using one command.

#  Configure a web server to use the nondefault document root /webfiles. In this directory, create a 
#  file index.html that has the contents hello world and then test that it works.

#  Configure your system to automatically start a mariadb container. This container should expose 
# its services at port 3306 and use the directory /var/mariadb-container on the host for 
# persistent storage of files it writes to the /var directory.

#  Configure your system such that the container created in step 15 is automatically started as a 
#  Systemd user container.
