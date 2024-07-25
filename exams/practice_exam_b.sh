Install a RHEL 9 virtual machine that meets the following requirements:
- 2 GB of RAM
- 20 GB of disk space using default partitioning
- One additional 20-GB disk that does not have partitions installed
- Server with GUI installation pattern
Create user student with password password, and user root with password password.

- System > Installation destination > the installer will overwrite an entire disk
- local standard disks 20G sda
- storage configuration set to automation 

- user settings > root password


#########################################################################################

Configure your system to automatically mount the ISO of the installation disk on the directory /repo. 
Configure your system to remove this loop-mounted ISO as the only repository that is used //
for installation. Do not register your system with subscription-manager, //
and remove all references to external repositories that may already exist.

lsblk

# identify the rom installation disk
sr0 # name of optical disk drive
# make an .iso of the sr0 device

dd if=/dev/sr0 of=/repo/rhel9.iso bs=1M

mkdir /repo

vi /etc/fstab
/rhel9.iso   /repo   iso9660     loop    0   0

mount -a
findmnt --verify
systemctl daemon-reload

cd /repo
AppStream   BaseOS

dnf config-manager --add-repo="file:///repo/AppStream
dnf config-manager --add-repo="file:///repo/BaseOS

dnf repolist

dnf install -y vim

#########################################################################################

Create a 1-GB partition on /dev/sdb. Format it with the vfat file system. Mount it //
persistently the directory /mydata, using the label mylabel.

mkdir /mydata

fdisk /dev/nvme1n1
n   1       +1G     p   w
mkfs.vfat -n mylabel /dev/nvme1n1p1

vim /etc/fstab
mylabel         /mydata     vfat    defaults    0   0

mount -a
systemctl daemon-reload


#########################################################################################

Set default values for new users. Ensure that an empty file with the name NEWFILE is copied //
to the home directory of each new user that is created.

cd /etc/skel/
touch NEWFILE

vim /etc/default/useradd
SKEL=/etc/skel # confirm this is present

useradd test
su - test
ls # NEWFILE is present!

########################################################################################

Create users laura and linda and make them members of the group livingopensource as a //
secondary group membership. Also, create users lisa and lori and make them members of //
the group operations as a secondary group.

groupadd livingopensource
groupadd operations

useradd -G livingopensource laura
useradd -G livingopensource linda

useradd -G operations lisa
useradd -G operations lori

cat /etc/group | tail -10
cat /etc/group | tail -10

#########################################################################################

Create shared group directories /groups/livingopensource and /groups/operations and make //
sure these groups meet the following requirements:
- Members of the group livingopensource have full access to their directory.
- Members of the group operations have full access to their directory.
- Users should be allowed to delete only their own files.
- Others should have no access to any of the directories.

mkdir -p /groups/livingopensource
mkdir -p /groups/operations

chown :livingopensource livingopensource
chown :operations operations

chmod 2770 livingopensource
chmod 2770 operations

drwxrws---.  2 root livingopensource   6 Jul 25 17:36 livingopensource
drwxrws---.  2 root operations         6 Jul 25 17:36 operations

#########################################################################################

Create a 2-GiB swap partition and mount it persistently.
Resize the LVM logical volume that contains the root file system and add 1 GiB. //
Perform all tasks necessary to do so.

fdisk /dev/nvme1n1

mkswap /dev/nvme1n1p2
swapon /dev/nvme1n1p2

lsblk --output=UUID /dev/nvme1n1p2 >> /etc/fstab
UUID  /myswap         swap    defaults        0       0

mount -a
findmnt --verify

dnf install -y lvm2

# cannot resize the root filesystem whilst it is mounted
used parted to do so

resize2fs /dev/rhel/root # if ext4
xfs_growfs / # this was run


#########################################################################################

Find all files that are owned by user linda and copy them to the //
file /tmp/lindafiles/.

find / -user linda -type f -exec cp --parent '{}' /tmp/lindafiles/ \;

#########################################################################################

Create user vicky with the custom UID 2008.

useradd -u 2008 vicky
cat /etc/passwd | grep vicky

#########################################################################################

Install a web server and ensure that it is started automatically.

dnf install -y httpd

vim /var/www/html/index.html
Hello examiner please pass me!

install and configure firewall to add http

curl localhost
# verify

#########################################################################################

Configure a container that runs the docker.io/library/mysql:latest image //
and ensure it meets the following conditions
- It runs as a rootless container in the user linda account.
- It is configured to use the mysql root password password.
- It bind mounts the host directory /home/student/mysql to the container //
  directory /var/lib/mysql.
- It automatically starts through a systemd job, where it is not needed //
  for user linda to log in.

cat /etc/passwd | grep linda # confirm

loginctl enable-linger linda
loginctl show-user linda # confirm lingering state

passwd linda
groupmod -U linda wheel # to allow sudo actions with linda

su - linda
sudo mkdir -p /home/student/mysql

chown linda:linda /home/student/mysql

podman pull docker.io/library/mysql:latest
podman images

podman inspect docker.io/library/mysql:latest # searching for env var format

podman run -d -e MYSQL_ROOT_PASSWORD=password -v /home/student/mysql:/var/liv/mysql:Z docker.io/library/mysql:latest

podman ps -a

podman generate systemd --name mysql --file --new
mkdir -p ~/.config/systemd/user/
mv container.service ~/.config/systemd/user/

systemctl --user enable container.service

reboot machine

ps faux | less
/linda

# look for the child process 

