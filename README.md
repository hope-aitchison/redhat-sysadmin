# redhat-sysadmin
some notes for redhat sysadmin (RHEL9)


# Podman notes
Running a container in detached mode means it runs in the background and keeps the terminal free for other tasks  
Detached mode is ideal for services that need to run continuously - like web servers, dbs, etc.  
Typically ports above 1024 are used for custom applications.  
Port mapping with containers is optional; if no ports specified when running the container, the container's ports are not accessible to the host. The container still runs with its default ports (check what this is using podman inspect).  

# SELinux notes  
Works with context labels.  
Source objects:  
- users
- processes (services)  
Source targets:  
- files & directories  
- ports  
When files are created within a directory they inherit the context of the parent directory - and same if a file is copied. But if a file is moved into a different directory, then it retains the original context.  
