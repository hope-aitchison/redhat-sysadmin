# Supporting info

* Without access to repositories a RHEL server cannot install software
* Registered RHEL servers have access to the Red Hat repositories
* All severs are offline for the exam - no repository access
* To configure repository access, a file with a name that ends in .repo needs to be added to /etc/yum.repos.d/
* Use dnf config-manager --add-repo to create the config file
* A URL to a repository may be provided in the exam

GPG = GNU Privacy Guard - ensures authenticity of the packages in a repository. 