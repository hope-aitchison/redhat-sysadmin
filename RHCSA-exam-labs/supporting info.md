# Supporting info

## Configuring remote repository access
* Without access to repositories a RHEL server cannot install software
* Registered RHEL servers have access to the Red Hat repositories
* All severs are offline for the exam - no repository access
* To configure repository access, a file with a name that ends in .repo needs to be added to /etc/yum.repos.d/
* Use dnf config-manager --add-repo to create the config file
* A URL to a repository may be provided in the exam

GPG = GNU Privacy Guard - ensures authenticity of the packages in a repository. 

## Configuring local repository access
* To create an ISO file, use the dd command
* To mount it persistently, add a line to /etc/fstab and use the iso9660 fs type
* Use dnf config-manager --add-repo or manually add a repository file to the /etc/yum.repos.d/ directory
* In the baseurl statement, use file:// as the resource type identifier

An ISO file is a single file that contains an exact copy (image) of the entire contents of a CD, DVD or Blu-ray disk.
OS's (Windows, macOS, Linux) allow you to mount an ISO file as a virtual drive, making its contents accessible. 

dd - convert and copy a file

BaseOS:
* contains core operating system packages
* Includes essential system software and services
AppStream:
* Contains additional applications and tools
* Developer utilities, e.g. git

dnf info git
This shows which repository a package was sourced from

rpm -qa | grep vim
sudo dnf info vim-enhanced
Check how a package is installed and under which name
Queries the rpm database

## Looping constructs
The for statement is used to evaluate range of items
Good for evaluating multiples files, arguments, usernames, etc
To remove a part from a string, matching operators can be used:
* ${name##*/} removes the longest match of the pattern */ from the left side
* ${name#*/} removes the shortest match of the pattern */ from the left side
* ${name%/*} removes the shortest match of the pattern /* from the right side
* ${name%%/*} removes the longest match of the pattern /* from the right side
To create a range of items in one command, put the items between {}

## Parameter expansion
In Bash, the ${VAR%PATTERN} syntax is part of parameter expansion, //
and it allows you to manipulate text within variables.

${VAR%PATTERN} - Remove the shortest match of PATTERN from the end
${VAR%%PATTERN} - Remove the longest match of PATTERN from the end
${VAR#PATTERN} - Remove the shortest match of PATTERN from the beginning
${VAR##PATTERN} - Remove the longest match of PATTERN from the beginning

### shortest match from end
FILENAME="file.txt.bak"
NO_EXT=${FILENAME%.txt.bak}
echo "$NO_EXT"
file

FULLPATH="dir/subdir/file.txt"
DIR=${FULLPATH%/*}
echo "$DIR"
dir/subdir

OLDNAME="file.txt"
NEWNAME=${OLDNAME%.txt}.bak
echo "$NEWNAME"
file.bak

### longest match from the beginning
FILENAME="document.pdf"
EXT=${FILENAME##*.}
echo "$EXT"
pdf

FULLPATH="dir/subdir/file.txt"
FILENAME=${FULLPATH##*/}
echo FILENAME
file.txt

## Conditionally executing code
if...then...else...fi is the basic strucute for conditionally executing code
To refer to one command line argument, use $1
To refer to an unknown number of command line arguments, use $@ in a while loop
Use read to prompt users for input and store them as an input variable


## Systemd
Unit files in systemd can be configured with many directives
List all directives using systemctl show

## Tuning
The linux kernel can be tweaked by modifying parameters in the /proc/sys directory
Persistent modifications should be made in /etc/sysctl.conf file or /etc/sysctl.conf.d/
Tuned comes with predefined performance profiles that match specific workloads

## MBR vs GPT
MBR = master boot record
GPT = GUID partition table
MBR is limited up to 2 TiB, due to 32 bit address space. 
MBR supports 4 primary partitions (if one is an extended partition). The 4th extended partition can then  
handle multiple logical partitions.
MBR stores the partition table in a single location (first 512 bytes on disk)
GPT supports disk sizes of higher than 2 TiB.
GPT can handle up to 128 partitions, no need for extended or logical partitions.
GPT stores a primary partition table at the beginning of the disk space, and a backup copy at the end  
of the disk space.

vfat filesystem is compatible with Linux, Windows, MacOS, i.e. very compatible.  
It does not support labels.

Check which partitioning scheme is in use:
```
parted /dev/disk print
fdisk -l
```
To show current labels and UUID for formatted devices
```
blkid
```
print the UUID to fstab
```
lsblk -o +UUID | grep nvme1n1p5 | awk '{ print $NF }' >> /etc/fstab
```

## Logical volumes
* LVM logical volumes are allocated from a volume group
* the vg is composed of one or more physical volumes, which represent available block devices
* If a partition is used as a pv, it should be marked with the lvm partition type
* you state the physical extent size when creating the volume group
* the pe is the minimum amount to be allocated from the volume group
* each vg uses one pe to store metadata (i.e there is always one held back)

## Swap memory
Swap memory makes working with Linux more efficient
Unused application memory can be moved to swap
Swap can be allocated on a block device or on a swap file  
Create a file with the dd utility - then it can be used as any other swap device

## Mounting filesystems
Specific mounting settings can be written into the /etc/fstab file
defaults = rw, suid, dev, exec, auto, nouser, async
### General
ro - mount the fs as read only
sync - writes are done synchronously
### Access control
nosuid - disables set user identifier and set group identifier bits for programmes
nodev - disables interpretation of device files
noexec - prevents execution of binaries on the fs
user / nouser - allows non-root user / root user only to mount the fs
### Performance optimisation
noatime - disables atime updates
relatime - updates atime only if previous atime is older than last modification time (mtime)
nodiratime - disables directory atime updates

## Autofs
Automatic mounting and unmounting of filesystems on demand.  
Useful for managing NFS (network shares) or local filesystems that are not always needed.  
Means these filesystems are mounted when accessed, and unmounted when idle.  
* autofs utilises the automount daemon
* after period of inactivity autofs unmounts the filesystem
* relies on master map file
* default timeout is 5 minutes, set TIMEOUT=N for global changes in /etc/sysconfig/autofs
* set --timeout=n in /etc/auto.master

## Resizing LVM volumes
To grow the size of a logical volume, free extents must be available in the vg
If no free extents are available, additional extents can be allocated by adding physical volumes  
to the volume group.  
While resizing the logical volume you should always use the -r option to resize  
the filesystem as well.
* xfs can only be extended
* ext4 can be extended or reduced

## Configuring directories for collaboration
Anything to do with collaboration will be aligned with Special Permissions.  
* Set group-ID ensures that all files created within a directory will be group-owned.  
* Sticky bit - if applied to a directory, guarentees that only the user that created the file  
will be able to delete the file.

## Scheduling tasks
cron jobs and systemd timers are not connected to the STDOUT so commands like echo  
are not suitable.

## Configuring time services
While booting, linux obtains its time from the hardware clock, and sets system clock.  
Continued time synchronisation is achieved by fetching internet time, using the chronyd service.

## Hostname resolution
In connected network environments, hostname resolution is provided by DNS.  
To configure a DNS client the etc/resolv.conf is used.  
If no DNS is available, then /etc/hosts is used.  
/etc/nsswitch.conf file is used to configure the order in which these files are used.  
In this file there is a line:  
hosts:      files dns myhostname  
This is the hierarchy, so anything within /etc/hosts takes precedence.

## Groups & user management
When creating a Linux user a group is created with the same name as the user.  
This is the primary group. The secondary group is created and configured separately.  
Default settings are in /etc/login.defs.  
Use chage command for more control over user password and account settings.  
passwd command allows for password expiration settings but less overall control.  

## Super user access
visudo command opens up the /etc/sudoers file, which contains examples.  

## Permissions
When finding a match Linux looks no further.  
Special permissions = sticky bit. Means group members can only delete files they have created.  
Sticky bit is achieved using chmod u/g/o+t dir/.  
All files created in directory with a group id, inherit the group owner of the directory.  
Group ID is achieved using chmod g+s dir/.  
Attributes can be used to prevent file operations regardless of permissions set.  
Default permission mode = 755  

## Sticky bit
Applies at the directory level and prevents all users from deleting or renaming files, unless  
they own them. Example:  
* group staff members given full permissions to a directory
* without sticky bit any member of staff group can delete or rename any file in that directory
* applying sticky bit means only file owners can delete / rename files, regardless of group membership  
Visually appears under "others" but its behaviour impacts all users.
