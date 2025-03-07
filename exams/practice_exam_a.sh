Install a RHEL 9 virtual machine that meets the following requirements:
- 2 GB of RAM
- 20 GB of disk space using default partitioning
- One additional 20-GB disk that does not have any partitions installed
- Server with GUI installation pattern
# done via VM GUI / desktop - 

#########################################################################################

Create user student with password password, and user root with password password.

#!/bin/bash

sudo -i
useradd student
passwd student: password

passwd root: password

#########################################################################################


Configure your system to automatically mount the ISO of the installation disk on //
the directory /repo. Configure your system to remove this loop-mounted ISO as the //
only repository that is used for installation. 
Do not register your system with subscription-manager, and remove all references //
to external repositories that may already exist.

#!/bin/bash

sudo -i
mkdir /repo

lsblk
# identify the installation disk
sr0

dd if=/dev/sr0 of=/rhel.iso bs=1M
# need to make sure optical disk is connected

df -h
/dev/mapper/rhel-root   (N)G # root logical volume

# mounts automatically
vi /etc/fstab
/rhel.iso   /repo   iso9660     loop    0   0 # loop mounted

# or 
echo '/rhel.iso /repo iso9660 loop 0 0' | sudo tee -a /etc/fstab

mount -a
findmnt --verify # check syntax
systemctl daemon-reload

ls /repo
AppStream   BaseOS

# create repo unit files 
cd /etc/yum.repos.d
vi base.repo
[BaseOS]
name=BaseOS Repo
baseurl=file:///repo/BaseOS
enabled=1
gpgcheck=0

vi appstream.repo
[AppStream]
name=AppStream Repo
baseurl=file:///repo/AppStream
enabled=1
gpgcheck=0

set other .repo files to enabled=0

dnf repolist # check which ones enabled
dnf install -y vim # check it's coming from local repo only

#########################################################################################

Reboot your server. Assume that you don’t know the root password, and use the appropriate //
mode to enter a root shell that doesn’t require a password. Set the root password to mypassword.

- grub bootloader menu whilst booting
- restart machine using vm software
- have cursor over the linux kernel and hit "e"
- add init=/bin/bash to end of the line starting with linux in the file that opens
- installation process is now in bash rather than systemd
- save the file and start the linux kernel (in bash shell)
- need to set the / directory to be rw

mount -o remount,rw /

passwd
mypassword
mypassword

touch /.autorelabel

exec /usr/lib/systemd/systemd # to reboot the system as reboot will not work
# can also reboot using VM software

# potentially need to manually remove the .autorelabel file if selinux stays relabelling

#########################################################################################

Set default values for new users. Set the default password validity to 90 days //
and set the first UID that is used for new users to 2000.

#!/bin/bash

sudo -i
mypassword

vim /etc/login.defs
...
PASS_MAX_DAYS   90
UID_MIN                  2000

#########################################################################################

Create users edwin and santos and make them members of the group livingopensource //
as a secondary group membership. Also, create users serene and alex and make //
them members of the group operations as a secondary group //
Ensure that user santos has UID 1234 and cannot start an interactive shell.

groupadd livingopensource
groupadd operations

useradd -G livingopensource  edwin
useradd -G livingopensource -u 1234 -s /sbin/nologin santos

useradd -G operations serene
useradd -G operations alex

getent group livingopensource
livingopensource:x:2002:edwin,santos

getent group operations
operations:x:2003:serene,alex

getent passwd edwin/santos/serene/alex
edwin:x:2000:2000::/home/edwin:/bin/bash
santos:x:1234:1234::/home/santos:/sbin/nologin
serene:x:2001:2001::/home/serene:/bin/bash
alex:x:2002:2004::/home/alex:/bin/bash

#########################################################################################

Create shared group directories /groups/livingopensource and /groups/operations, //
and make sure the groups meet the following requirements:
Members of the group livingopensource have full access to their directory.
Members of the group operations have full access to their directory.
New files that are created in the group directory are group owned by the group owner //
of the parent directory.
Others have no access to the group directories.

mkdir -p /groups/livingopensource
mkdir -p /groups/operations

cd /groups

chmod g+w livingopensource
chmod g+w operations

ls -la

chown :livingopensource livingopensource/
chown :operations operations/
ls -la

chmod 2770 livingopensource
chmod 2770 operations
ls -la

touch livingopensource/file
ls -la livingopensource/
-rw-r--r--. 1 root livingopensource  0 Jul 25 07:41 file

#########################################################################################

Create a 2-GiB volume group with the name myvg, using 8-MiB physical extents. //
In this volume group, create a 500-MiB logical volume with the name mydata, //
and mount it persistently on the directory /mydata.

# create a free partition
gdisk /dev/nvme1n1
n   1   +2G     8e00    w   Y   

# define the physical extent size when creating the volume group
vgcreate -s 8M myvg /dev/nvme1n1p1

expr 500 / 8

lvcreate -l 63 -n mydata /dev/myvg
# lvextend -l +1 /dev/myvg/mydata

mkfs.xfs /dev/myvg/mydata # needs a fs to be mounted 
mkdir /mydata # xfs is the default rhel_9 filesystem

echo "/dev/myvg/mydata /mydata xfs defaults 0 0" >> /etc/fstab
mount -a
findmnt --verify
systemctl daemon-reload

#########################################################################################

Find all files that are owned by user edwin and copy them to the directory /rootedwinfiles.

mkdir /rootedwinfiles

find / -type f -user edwin -exec cp --parents '{}' /rootedwinfiles/ \;

#########################################################################################

Schedule a task that runs the command touch /etc/motd every day from Monday //
through Friday at 2 a.m.

vim /etc/crontab # for layout
crontab -e
0 2 * * 1-5 touch /etc/motd

crontab -l # to display

cat /var/log/messages | tail -10 # check message output
car /var/log/cron | tail -10 # check cron logs

#########################################################################################

Add a new 10-GiB virtual disk to your virtual machine. On this disk, add a Stratis //
volume and mount it persistently.

dnf install -y stratis-cli
dnf install -y stratisd

systemctl start stratis
systemctl status stratis

stratis pool list # check space in pool

wipefs -a /dev/nvme1n1 # had to do this to clean up ownership
stratis pool create mypool /dev/nvme1n1 # add the 10G disk to pool mypool

stratis pool list # verify

stratis fs create mypool myfs # create the filesystem myfs

stratis fs list # verify

mkdir /myfs

lsblk --output=UUID /dev/stratis/mypool/myfs >> /etc/fstab
vim /etc/fstab
UUID    /myfs   xfs     stratis     0   0
mount -a
findmnt --verify
systemctl daemon-reload 

lsblk -f # final verification

#########################################################################################

Create user bob and set this users shell so that this user can only change the password //
and cannot do anything else.

useradd bob

cd /usr/local/bin/
vim bob_password_shell.sh

#!/bin/bash
echo "Change your password Bob!"
exec /usr/bin/passwd

chmod +x bob_password_shell.sh # make sure it is executable

vim /etc/passwd
# edit bob's entry:
bob:x:2003:2005::/home/bob:/usr/local/bin/bob_passwd_shell.sh

su - bob
Change your password Bob!
Changing password for user bob.

#########################################################################################

Install the vsftpd service and ensure that it is started automatically at reboot.

dnf install -y vsftpd
systemctl enable vsftpd # this step means it starts on reboot
systemctl start vsftpd

dnf install -y firewalld
systemctl enable firewalld
systemctl start firewalld

firewall-cmd --get-services | grep ftp

firewall-cmd --add-service ftp --permanent
firewall-cmd --reload


#########################################################################################


Create a container that runs an HTTP server. Ensure that it mounts the host directory //
/httproot on the directory /var/www/html.
Configure this container such that it is automatically started on system boot as a //
system user service.

dnf install -y podman
dnf install -y container-tools

mkdir /httproot

podman search http | less
# select an image

podman pull registry.access.redhat.com/rhscl/httpd-24-rhel7:latest

podman run --rm -it --entrypoint /bin/sh registry.access.redhat.com/rhscl/httpd-24-rhel7
cd /var/www/html # confirm directory present

podman run -d -p 80:80 --name http_server -v /httproot:/var/www/html:Z registry.access.redhat.com/rhscl/httpd-24-rhel7

podman ps -a # confirm its running

cd /etc/systemd/system/
podman generate systemd --name http_server --files --new
ls 
container-http_server.service

systemctl start container-http_server.service
systemctl enable container-http_server.service # should now start on boot

#########################################################################################

Create a directory with the name /users and ensure it contains the subdirectories //
linda and anna. Export this directory by using an NFS server.

Create users linda and anna and set their home directories to /home/users/linda and //
/home/users/anna. Make sure that while these users access their home directory, //
autofs is used to mount the NFS shares /users/linda and /users/anna from the same server.

mkdir /users
cd /users
mkdir linda
mkdir anna
ls

dnf install -y nfs-utils

systemctl start nfs-server
systemctl enable nfs-server

vim /etc/exports
/users      *(rw,no_root_squash)

exportfs -r 
exportfs -v # verify


systemctl status firewalld
for i in rpc-bind mountd nfs; do firewall-cmd --add-services $i //
--permanent ; done

firewall-cmd --reload
firewall-cmd --list-services

useradd -d /home/users/linda -m linda
useradd -d /home/users/anna -m anna

dnf install -y autofs
vim /etc/auto.master

/home/users     /etc/auto.user

linda -rw localhost:/users/linda
anna  -rw localhost:/users/anna
# replace localhost with nfsserver hostname or IP

systemctl enable --now autofs
systemctl start autofs

cd /home/users
# empty...
cd linda
# works!
