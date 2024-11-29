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