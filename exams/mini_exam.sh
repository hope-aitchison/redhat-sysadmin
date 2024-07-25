1.	install httpd and configure it to run on port 82
2.	create user lori and set her shell to /sbin/nologin
3.	find all files in the /etc directory containing the text "strator" and //
    write a list of the filenames to /txt/stratorfiles.txt
4.	create a symbolic link with the name /tmp/hosts, pointing to /etc/hosts
5.	create a group sales, and a shared group directory /data/sales. 
    Ensure that all new files in this directory are group-owned by the group sales
6.	create an LVM volume with a size of 50 extents. 
    If necessary, grow an existing volume group to do so
7.	set the recommended tuned profile for your system 

###########################################
## 1

sudo -i

dnf install -y httpd
dnf install -y vim

systemctl enable httpd
systemctl start httpd
systemctl status httpd

vim /etc/httpd/conf/httpd.conf
Listen 82

cd /var/www/html/
vim index.html
Testing port 82 works and it does!

man semanage-port
examples

semanage port -l | grep http

semanage port -a -t http_port_t -p tcp 82 # got this from man pages

systemctl restart httpd
systemctl status httpd

curl localhost:82
Testing port 82 works and it does!

# would have been good to use getenforce, setenforce permissive
# check selinux blocking connection

###########################################
## 2

useradd lori -s /sbin/nologin

###########################################
## 3

find /etc -type f -exec grep -l "strator" {} \; > /txt/stratorfiles.txt
# or
find /etc -type f | xargs grep -l "strator" > /txt/stratorfiles.txt

###########################################
## 4

ln -s /etc/hosts /tmp/hosts
ls -la /tmp/hosts # l present

###########################################
## 5

mkdir /data/sales
cd /data/
groupadd sales

chown :sales sales/
chmod 2770 sales/
ls -la
drwxrws---.  2 root sales   6 Jul 24 18:32 sales

touch sales/text
ls -la sales
-rw-r--r--. 1 root sales  0 Jul 24 18:35 text

###########################################
## 6

dnf install -y lvm2

lsblk

gdisk /dev/nvme1n1
n   1       +1G     8e00    p   w   Y
lsblk
# partition created

vgcreate vgtest /dev/nvme1n1p1

lvcreate -l 50 -n lvtest /dev/vgtest

vgdisplay
  PE Size               4.00 MiB
  Total PE              255
  Alloc PE / Size       50 / 200.00 MiB

lvdisplay
  LV Size                200.00 MiB
  Current LE             50

lsblk
nvme1n1           259:5    0   10G  0 disk
└─nvme1n1p1       259:6    0    1G  0 part
  └─vgtest-lvtest 253:0    0  200M  0 lvm

###########################################
## 8

man tuned # advised to see tuned-adm

tuned-adm list # available profiles

tuned-adm recommend
# virtual guest

tuned-adm profile virtual-guest

tuned-adm active
# virtual guest
