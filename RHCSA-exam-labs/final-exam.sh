#!/bin/bash

# 1 - Copy the content of the RHEL 9.x installation disk to the /rhel9.iso file
# Mount this iso file on the /repo directory
# Configure your system to use this local /repo directory as a repository, providing
# access to the BaseOS and AppStream packages.

sudo -i

# check the CDRom is connected using virtual machine UI

lsblk

dd if=/dev/sr0 of=/rhel.iso bs=1M

mkdir /repo

vim /etc/fstab
/rhel.iso   /repo   iso9660     defaults    0   0

mount -a
systemctl daemon-reload

dnf config-manager --add-repo=file:///repo/AppStream
dnf config-manager --add-repo=file:///repo/BaseOS

dnf repolist

# test
dnf install -y nmap
# GPG keys enabled so doesn't work

cd /etc/yum.repos.d/
vim BaseOS.repo
gpgcheck=0
vim AppStream.repo
gpgcheck=0

dnf install -y nmap


# 2 - Locate all files with a size bigger than 200 MiB. Do not include any directories.
# Use the ls -l command to write a list of all the files to the directory /root/bigfiles.txt

find / -type f -size +200M -exec ls -l '{}' \; > /root/bigfiles.txt


# 3 - Write a script that can be used as a countdown timer, meeting the following requirements:
# * name = countdown.sh
# * script should take a number of minutes as its argument
# * if no argument provided, the script should prompt the user to enter a value and use that
# * While running, the script should print "nn seconds remaining", where nn is the 
# number of seconds. This should happen every second. The current number of seconds should
# be stored in a variable COUNTER.
# * script should count down seconds to 0. When second 0 is reached, the script should
# stop and print the message "countdown is now finished".
# * script should be copied to the recommended location in the search path of regular users.

bash -x countdown.sh # runs the script in debug mode
$(( )) # bash internal calculator, put sum in between brackets

#!/bin/bash

if [ -z $1 ]; then
    echo You need to enter the number of minutes
    read COUNTER
else
    COUNTER=$1
fi

COUNTER=$(( COUNTER * 60 ))

while [ $COUNTER -gt 0 ]; do
    echo $COUNTER seconds remaining
    COUNTER=$(( COUNTER - 1 ))
    sleep 1
done

echo countdown is now finished

# search path of regular users
/usr/local/bin
cp countdown.sh /usr/local/bin


# 4 - Run the command sleep infinity with adjusted priority. Make sure it meets the following:
# * it should get the lowest priority that can be set
# * it should automatically be started as a background job when the user "student" logs in

ssh student@localhost

# either
/home/student/.bash_profile 
/home/student/.bashrc

nice
renice # for running process
-20 to 19 (-20 being the top priority)

& # runs processes in background

nice -n 19 sleep infinity & >> .bash_profile

exit

ssh student@localhost

ps aux | grep sleep 

# 5 - On secondary hard disk create a primary partition that meets the following:
# * GPT paritioning scheme is used
# * Partition has a size of 2 GiB
# * After creation it will be listed as the first partition
# Create another partition that meets the following:
# * The size is 5 GiB
# * The partition type is set to lvm

fdisk /dev/nvme1n1
g, n, 1, , +2G
n, 2, , +5G, t, 80, w

lsblk


# 6 - Create an LVM setup that meets the following requirements:
# * volume group with the name "vglabs" and uses the LVM partition created in 5
# * vg uses a physical extent size of 2 MiB
# * logical volume with the name "lvlabs" created. It uses 50% of disk space within vg.

dnf install -y lvm2

vgcreate -s 2M vglabs /dev/nvme1n1p2
lvcreate -n lvlabs -l 50%FREE vglabs

lsblk 

# 7 - Create and mount filesystems on the previously created devices, meeting the following:
# * the partition uses the xfs filesystem. Mounted persistently using its UUID on /data
# * logical volume uses ext4 fs mounted persistently on /files
# Use /etc/fstab for persistent mounting, not systemd mounts
# Use systemd mount provided by a default installation to mount /tmp directory persistently
# using the tmpfs driver. Should not be seen in /etc/fstab.

mkfs.xfs /dev/nvme1n1p1
mkfs.ext4 /dev/vglabs/lvlabs

lsblk -o UUID /dev/nvme1n1p1 >> /etc/fstab
UUID=xxx    /data   xfs     defaults    0   0
/dev/vglabs/lvlabs      /files  ext4    defaults    0   0

mkdir /data
mkdir /files

mount -a
systemctl daemon-reload

lsblk -f
mount

systemctl list-unit-files -t mount

systemctl status tmp.mount

cat /usr/lib/systemd/system/tmp.mount

systemctl enable tmp.mount
# do not use just flag to mount at reboot

reboot

systemctl status tmp.mount

# 8 - Create a simple systemd unit with the name sleep.service.
# * It runs the sleep 3600 command
# * The unit is stored in the appropriate location for admin-created unit files
# * Unit is automatically started in multi-user.target
# * If stops for any reason it automatically restarts

cd /etc/systemd/system/

[Unit]
Description=sleep service

[Service]
ExecStart=/usr/bin/sleep 3600
Restart=on-failure

[Install]
WantedBy=multi-user.target

# 9 - Set the hostname of your test machine to "examlabs.example.com"
# Install and enable the httpd service using default configuration.
# Ensure that the firewall allows non-secured access to the httpd service.

dnf install -y httpd

systemctl enable --now httpd

dnf install -y firewalld

systemctl start firewalld

firewall-cmd --get-services | grep http

firewall-cmd --add-service http --permanent

firewall-cmd --reload

firewall-cmd --list-services

10 - Make sure that new users require a password with a maximal validity of 90 days
Ensure that while creatings users an empty file with the name newfile is created to their home dir
Create users anna anouk linda and lisa
Set the passwords for all users to password
Create the groups profs and students, make anna and anouk members of profs, linda and lisa memebers of students
Create a shared group directory structure /data/profs and /data/students
Members of the groups have full read and write access to their directories
Others have no permissions at all.

vim /etc/login.defs
MAX_PASS_AGE = 90

cd /etc/skel
touch newfile

useradd anna
useradd anouk linda lisa
useradd anouk
useradd linda
passwd anna
passwd anouk
passwd linda
passwd lisa
chage anaa
cat /etc/passwd | grep anna
su - anna
ls
exit
groupadd profs
groupadd students
usermod --help
usermod -aG profs anna
usermod -aG profs anouk
usermod -aG students linda
usermod -aG students lisa

cat /etc/group

mkdir -p /data/{profs,students}
cd /data
ls -l
chown :profs profs
chown :students students
ls -l
chmod 770 profs
chmod 770 students

# Task 11 - Configure the httpd service to meet the following requirements
# The DocumentRoot in /etc/httpd/conf/httpd.conf is set to /web
# Create a file /web/index.html that contains the test "hello from /web"
# Include the following in /etc/httpd/conf/httpd.conf to configure Apache to allow access from non-default DocumentRoot
# <Directory "/web">
# Verify that the content is served from the non default DocumentRoot

vim /etc/httpd/conf/httpd.conf
DocumentRoot "/web"
...
<Directory "/web">

mkdir /web
vim /web/index.html
hello from /web

systemctl restart httpd

man semanage-fcontext

semanage fcontext -a -t httpd_sys_content_t "/web(/.*)?"
restorecon -R -v /web

curl http://localhost

# Task 12 - Using the containerfile listed below
# Build a container image with the name greeter based on the Containerfile
# Run this image as a container with the name sleeper

dnf install -y podman container-tools

vim Containerfile

FROM registry.access.redhat.com/ubi8/ubi:latest
CMD ["/usr/bin/echo", "hello all"]

podman build -t greeter .

podman run --name sleeper greeter:latest

# Task 13 - Ensure full access to Red Hat repositories 
# Run Mariadb container based on the registry.redhat.io/rhel9/mariadb-105 image
# Container is started as a rootless container by student
# Container must be accessible at host port 3306
# Database root password should be set to password
# Container uses the name mydb
# A bind-mounted directory is accessible /home/student/mariadb on the host mapped to /var/lib/mysql in container

su - student

mkdir /home/student/mariadb
podman unshare chown 27:27 mariadb/
podman unshare ls -l

sudo loginctl enable-linger student
sudo loginctl show-user student

cat /etc/containers/registries.conf | grep unqualified
podman login registry.redhat.io
podman search mariadb-105
podman pull registry.redhat.io/rhel9/mariadb-105
podman images

podman inspect registry.redhat.io/rhel9/mariadb-105 | less
podman inspect registry.redhat.io/rhel9/mariadb-105 >> inspect

podman images
podman run -d -v /home/student/mariadb:/var/lib/mysql:Z -e MYSQL_ROOT_PASSWORD=password -p 3306:3306 --name mydb registry.redhat.io/rhel9/mariadb-105
podman ps

ss -tunap
ps aux | grep student

# Task 14 - Configure the container mydb that was created in previous task to automatically by started by systemd when system boots
# Ensure the container will also be started if the user student does not log in after the system has been started

man podman-generate-systemd

mkdir -p ~/.config/systemd/user
cd ~/.config/systemd/user

podman images
podman generate systemd --new --files mydb
systemctl --user enable container-xxx.service

sudo reboot

...

sudo -i

ps aux | grep
su - student
podman ps