#!/bin/bash

## Performing container management
# Log in to the default Red Hat container registries
# Start the bitnami nginx container image in detached mode 
# conigure so that this container is accessible from host port 81

# on the exam they will provide a username and password to access the registries

dnf install -y podman
dnf install -y container-tools

cat /etc/containers/registries.conf
...
unqualified-search-registries = ["registry.access.redhat.com", "registry.redhat.io", "docker.io"]

podman login registry.redhat.io
hopeaitchison
password

podman search bitnami
docker pull docker.io/bitnami/nginx

podman images
REPOSITORY               TAG         IMAGE ID      CREATED     SIZE
docker.io/bitnami/nginx  latest      f5c585c24508  4 days ago  190 MB

# check exposed ports
podman inspect bitnami/nginx
...
               "ExposedPorts": {
                    "8080/tcp": {},
                    "8443/tcp": {}

podman run -d --name nginx -p 81:8080 f5c585c24508

podman ps
CONTAINER ID  IMAGE                           COMMAND               CREATED        STATUS        PORTS                                     NAMES
4b83c36ed1ad  docker.io/bitnami/nginx:latest  /opt/bitnami/scri...  7 seconds ago  Up 7 seconds  0.0.0.0:81->8080/tcp, 8080/tcp, 8443/tcp  nginx

## Managing storage
# as user linda create a container with the name "mydb"
# starts the mariadb-105 image based on RHEL9
# container /var/lib/mysql is mounted on directory /mydb in linda home directory
# container is started in the background
# container MYSQL_ROOT_PASSWORD is set to "password"
# SELinux is operational and allowing access

# login to a linda shell
ssh linda@localhost

# change host directory ownership to match UID of container user

# login to redhat registry and pull container
cat /etc/containers/registries.conf
podman login registry.redhat.io

podman search mariadb-105
podman pull registry.redhat.io/rhel9/mariadb-105
podman images
REPOSITORY                            TAG         IMAGE ID      CREATED      SIZE
registry.redhat.io/rhel9/mariadb-105  latest      beb17ebc4834  2 hours ago  489 MB

podman inspect registry.redhat.io/rhel9/mariadb-105
# search for user

# or run a temporary container and check service uids
podman run --it registry.redhat.io/rhel9/mariadb-105 /bin/sh
cat /etc/passwd 

uid=27(mysql) gid=27(mysql) groups=27(mysql),0(root)

# rootless container so run user namespace
podman unshare chown 27:27 /home/linda/mydb 
podman unshare ls -ls /home/linda/mydb


# run the container
podman -d --name mariadb -v /home/linda/mydb:/var/lib/mysql:Z -e MYSQL_ROOT_PASSWORD=password registry.redhat.io/rhel9/mariadb-105

CONTAINER ID  IMAGE                                        COMMAND     CREATED         STATUS                 PORTS       NAMES
d6994353b063  registry.redhat.io/rhel9/mariadb-105:latest  run-mysqld  56 seconds ago  Up Less than a second  3306/tcp    mariadb

# confirm diretories have mounted
cd mydb
data  mysql.sock

podman exec -it mariadb /bin/sh
cd /var/lib/mysql
data  mysql.sock


## Using containerfile
# using the containerfile, build a container image with the name "helloworld:1.0" 
# Start this container image once

podman build -t helloworld:1.0 . # podman will find the containerfile if you reference the directory
podman images # show the image is present
REPOSITORY            TAG         IMAGE ID      CREATED      SIZE
localhost/helloworld  1.0         f79f784d53c3  4 hours ago  213 MB

podman run -d localhost/helloworld
podman ps


## Systemd integration
# Create a systemd unit file that will start the "mydb" container created earlier as user "linda"
# The container should automatically be started when the system boots and not depend on the user login

# activate user linda to enable container to not depend on user login
sudo loginctl enable-linger linda
sudo loginctl user-status linda
linda (1002)
           Since: Tue 2025-01-21 12:49:01 UTC; 2s ago
           State: lingering
          Linger: yes
            Unit: user-1002.slice
                  └─user@1002.service
                    └─init.scope
                      ├─19289 /usr/lib/systemd/systemd --user
                      └─19291 "(sd-pam)"

sudo loginctl show-user linda
UID=1002
GID=1002
Name=linda
Timestamp=Tue 2025-01-21 12:49:01 UTC
TimestampMonotonic=8961521404
RuntimePath=/run/user/1002
Service=user@1002.service
Slice=user-1002.slice
State=lingering
Sessions=
IdleHint=yes
IdleSinceHint=0
IdleSinceHintMonotonic=0
Linger=yes

# log out and then back in as linda

man podman-generate-systemd
man podman-systemd.unit

mkdir -p /home/linda/.config/systemd/user

podman generate systemd --files --new --name mariadb

systemctl --user enable container-great_austin.service

reboot

sudo -i # log in as root, not linda
ps aux | grep linda

/usr/bin/conmon # this is the container monitor
