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

# add linda to group wheel for sudo access & create password
useradd linda -G wheel
cat /etc/group | grep wheel
passwd linda

# update selinux label for ~/mydb
su - linda
sudo semanage fcontext -a -t container_file_t "/home/linda/mydb(/.*)?"
sudo restorecon -RFv /home/linda/mydb
Relabeled /home/linda/mydb from unconfined_u:object_r:user_home_t:s0 to system_u:object_r:container_file_t:s0

# change host directory ownership
# run a temporary container and check service uids
podman run --rm registry.redhat.io/rhel9/mariadb-105 id mysql
uid=27(mysql) gid=27(mysql) groups=27(mysql),0(root)

chown 27:27 /home/linda/mydb
chmod 777 /home/linda/mydb

# activate user linda to allow container to run in background
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

# login to redhat registry and pull container
cat /etc/containers/registries.conf
podman login registry.redhat.io

podman search mariadb-105
podman pull registry.redhat.io/rhel9/mariadb-105
podman images
REPOSITORY                            TAG         IMAGE ID      CREATED      SIZE
registry.redhat.io/rhel9/mariadb-105  latest      beb17ebc4834  2 hours ago  489 MB

# run the container
podman -d --name mariadb -v /home/linda/mydb:/var/lib/mysql:Z -e MYSQL_ROOT_PASSWORD=password registry.redhat.io/rhel9/mariadb-105

CONTAINER ID  IMAGE                                        COMMAND     CREATED         STATUS                 PORTS       NAMES
d6994353b063  registry.redhat.io/rhel9/mariadb-105:latest  run-mysqld  56 seconds ago  Up Less than a second  3306/tcp    mariadb


## Using containerfile

## Systemd integration