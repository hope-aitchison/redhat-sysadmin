## questions not yet encountered

Create a group sysadmins. Make users linda and anna members of this //
group and ensure that all members of this group can run all //
administrative commands using sudo.

groupadd sysadmins

useradd -G sysadmins linda
useradd -G sysadmins linda

visudo

%sysadmins ALL=(ALL) ALL # % because referring to a group not a user


#########################################################################################

Create a directory /users/ and in this directory create the directories user1 through //
user5 using one command.

mkdir -p /users/user{1..5}

#########################################################################################

Set default values for new users. A user should get a warning three //
days before expiration of the current password. //
Also, new passwords should have a maximum lifetime of 120 days.

vim /etc/login.defs

#########################################################################################

Create a configuration that allows user laura to run all //
administrative commands using sudo.

cd /etc/sudoers.d/


#########################################################################################

Add a 10-GiB disk to your virtual machine. On this disk, //
create a Stratis pool and volume. Use the name stratisvol for the //
volume, and mount it persistently on the directory /stratis.

dnf install -y stratisd
dnf install -y stratis-cli

stratis pool create mypool /dev/nvme1n1
stratis pool # verify

stratis fs create mypool statisvol

mkdir /stratis

lsblk --output=UUID /dev/stratis/mypool/stratisvol >> /etc/fstab
UUID /stratis   xfs     stratis     0   0

mount -a
systemctl daemon-reload

