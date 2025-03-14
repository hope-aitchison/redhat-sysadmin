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

/etc/security/pwquality.conf
minlength = 6

systemtl daemon-reload

# Create users linda and anna and make them members of the group sales as a secondary group membership. 
# Also, create users serene and alex and make them members of the group account as a secondary group.

groupadd membership
groupadd account

useradd -G membership anna linda
useradd -G account serene alex

#  Configure an SSH server that meets the following requirements:
#  User root is allowed to connect through SSH.
#  The server offers services on port 2022.

systemctl status sshd

cd /etc/ssh/sshd_config

port 2022
PermitRootLogin yes

semanage port -a -t ssh_port_t -p tcp 2022
semanage port -l | grep ssh

systemctl daemon-reload
systemctl start sshd
systemctl status sshd


#  Create a 4-GiB volume group, using a physical extent size of 2 MiB. In this volume group, 
#  create a 1-GiB logical volume with the name myfiles, format it with the Ext3 file system, 
#  and mount it persistently on /myfiles.

  dnf install -y lvm2

  lsblk
  fdisk /dev/nvme1n1
  lsblk

  pvcreate /dev/nvme1n1p1
  pvs

  vgcreate -s 2M myvg /dev/nvme1n1p1
  vgdisplay

  lvcreate -L 1G -n myfiles myvg
  lvdisplay
  lsblk

  mkfs.ext3 /dev/myvg/myfiles
  lsblk -f
  
  mkdir /myfiles

  lsblk -o UUID /dev/myvg/myfiles
  lsblk -o UUID /dev/myvg/myfiles >> /etc/fstab
  vim /etc/fstab
  UUID=xxxx	/myfiles	ext3	defaults 	0	0

  mount -a
  systemctl daemon-reload
  lsblk


#  Create a group sysadmins. Make users linda and anna members of this group and ensure that all 
#  members of this group can run all administrative commands using sudo.

groupadd sysadmins

useradd -aG sysadmins linda
useradd -aG sysadmins anna
groups anna
groups linda

visudo 

%sysadmins ALL=(ALL)    ALL

su - linda
sudo whoami
root

#  Optimize your server with the appropriate profile that optimizes throughput.
tuned-adm list

tuned-adm profile network-throughput

tuned-adm active
Current active profile: network-throughput

#  Add a new disk to your virtual machine with a size of 10 GiB. On this disk, create a LVM logical volume
#  with a size of 5 GiB, configure it as swap, and mount it persistently.

Add disk through UI

fdisk

mkswap /dev/nvme1n1p1
swapon /dev/nvme1n1p1

lsblk -f

lsblk -o UUID /dev/nvme1n1p1 >> /etc/fstab
UUID=xxx    none    swap    defaults    0   0
mount -a

reboot

swapon --show


#  Create a directory /users/ and in this directory create the directories user1 through user5 
#  using one command.

mkdir -p /users/user{1..5}


#  Configure a web server to use the nondefault document root /webfiles. In this directory, create a 
#  file index.html that has the contents hello world and then test that it works.

dnf install -y httpd
systemctl start httpd

cd /etc/httpd/conf
vim httpd.conf

DocumentRoot "/webfiles/"
...
# Further relax access to the default document root:
<Directory "/webfiles/">

mkdir /webfiles
vim index.html
hello world

semanage fcontext -a -t httpd_sys_content_t "/webfiles(/.*)?"
restorecon -R -v /webfiles

ls -lZ

systemctl restart httpd

curl http://localhost
hello world

error logs: /var/log/httpd/error_logs


#  Configure your system to automatically start a mariadb container. This container should expose 
# its services at port 3306 and use the directory /var/mariadb-container on the host for 
# persistent storage of files it writes to the /var directory.

vim /etc/containers/registries.conf
podman login podman login registry.access.redhat.com
podman login registry.redhat.io

podman search mariadb

podman pull registry.redhat.io/rhel9/mariadb-1011

podman image list

podman inspect registry.redhat.io/rhel9/mariadb-1011 | less
User: 27

mkdir -p /var/mariadb-container

podman run -d -p 3306:3306 -v /var/mariadb-container:/var:Z -e MARIADB_ROOT_PASSWORD=password registry.redhat.io/rhel9/mariadb-1011
# wouldn't run without passing the e var checked podman logs registry.redhat.io/rhel9/mariadb-1011

podman ps 

ss -tlnp 
LISTEN  0        4096     0.0.0.0:3306     0.0.0.0:*     users:(("conmon",pid=24340,fd=5))

ls -l /var/mariadb-container

#  Configure your system such that the container created in step 15 is automatically started as a 
#  Systemd user container.

man podman-generate-systemd # good examples

cd /etc/systemd/system
podman generate --new --files container-name

systemctl enable container-name.service

reboot

ps faux | grep conmon

systemctl status container-name.service
podman ps
