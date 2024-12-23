## Supporting info

### Configuring remote repository access
* Without access to repositories a RHEL server cannot install software
* Registered RHEL servers have access to the Red Hat repositories
* All severs are offline for the exam - no repository access
* To configure repository access, a file with a name that ends in .repo needs to be added to /etc/yum.repos.d/
* Use dnf config-manager --add-repo to create the config file
* A URL to a repository may be provided in the exam

GPG = GNU Privacy Guard - ensures authenticity of the packages in a repository. 

### Configuring local repository access
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

### Looping constructs
The for statement is used to evaluate range of items
Good for evaluating multiples files, arguments, usernames, etc
To remove a part from a string, matching operators can be used:
* ${name##*/} removes the longest match of the pattern */ from the left side
* ${name#*/} removes the shortest match of the pattern */ from the left side
* ${name%/*} removes the shortest match of the pattern /* from the right side
* ${name%%/*} removes the longest match of the pattern /* from the right side
To create a range of items in one command, put the items between {}

### Parameter expansion
In Bash, the ${VAR%PATTERN} syntax is part of parameter expansion, //
and it allows you to manipulate text within variables.

## parameter expansion

${VAR%PATTERN} - Remove the shortest match of PATTERN from the end
${VAR%%PATTERN} - Remove the longest match of PATTERN from the end
${VAR#PATTERN} - Remove the shortest match of PATTERN from the beginning
${VAR##PATTERN} - Remove the longest match of PATTERN from the beginning

# shortest match from end
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

# longest match from the beginning
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