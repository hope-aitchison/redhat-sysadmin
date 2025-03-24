#!/bin/bash

sudo dnf install -y podman
sudo dnf install -y container-tools

podman --version

# check the list of registries podman uses to search for images
cat /etc/containers/registries.conf

# An array of host[:port] registries to try when pulling an unqualified image, in order.
unqualified-search-registries = ["registry.access.redhat.com", "registry.redhat.io", "docker.io"]

# authenticate against registry
podman login registry.redhat.io

# check which images have been pulled and are available locally
podman images

# checks which images are available remotely and pull them to the local server
podman search {image-name} | less
podman pull {image-name}: latest # with most recent tag

podman search nginx # example

# verify what images are downloaded locally
podman images

# check metadata like config and exposed ports
podman inspect {image-name}

# delete image from local system
podman rmi {image-name}

# run a temporary container from the image and open an interactive shell
podman run --rm -it {image-id} /bin/sh

# specific options for this command
podman run --help

# once you pull an image it is available locally but you still need to create / run a container from the image
podman run -d --name mydb {image-ID}

# if container does not run correctly e.g. env variable required
podman logs {container-ID}

# nginx example
podman run -d --name webserver -p 8080:80 nginx

# mariadb example
podman run -d --name mydb -e MYSQL_ROOT_PASSWORD=password {image-name:image-tag}

# list all running containers including stopped ones
podman ps -a

# available ports
sudo dnf install -y net-tools
sudo netstat -tuln
sudo ss -tuln

# in the event that the default mariadb port is already in use or a specific port usage required
podman run -d --name mydb -e MYSQL_ROOT_PASSWORD=password -p 3307:3306 {image-name:image-tag}
# 3307 host port and 3306 is container port

# stop and remove
podman stop {container-name}
podman stop -a
podman rm {container-name}
podman rm -a
podman stop -a && podman rm -a # combined total clearout
podmam ps -a # verify

# execute a task within a container
podman exec -it {container-name} {command}
# example
podman exec -it webserver /bin/bash


# namespaces
# create new namespace
podman unshare {command}

# allows you to give the user id (UID) as it occurs within the container permissions to a host directory

## volumes
# volumes help retain data after container removal
# attach a host directory

podman run -d --name my-container -v /host/directory:/container/directory:Z image-name
# for logs
mkdir -p /data/logs
podman run -d --name nginx-server -v /data/logs:/var/log/nginx:Z nginx

# podman volumes
podman volume create mydata

podman run -d --name db-server -v mydata:/var/lib/mysql mysql

podman volume inspect mydata

podman volume ls

podman volume rm mydata

# persisting storage across reboots

ExecStart=/usr/bin/podman run --name my-service -v /data/storage:/app/data:Z myimage
systemctl daemon-reload
systemctl enable --now my-service.service


## Exam style task
# Create a container with the name mydb that runs the mariadb database as user lisa 
# The container should automatically be started at system start - regardless of whether or not user lisa is logging in
# 
# The host directory /home/lisa/mydb is mounted on the container directory /var/lib/mysql 
# The container is accessible on host port 3206
# You do not have to create any databases in it

## Solution

# allow user lisa to run as a process upon system start
sudo useradd lisa
sudo loginctl enable-linger lisa
sudo loginctl show-user lisa
...
Linger=yes
...

# make directory & install tools
pwd
mkdir mydb
ls 

sudo dnf install -y container-tools
sudo dnf install -y podman

ls -ld mydb # to show current ownership
stat mydb # displays UID and GID values

# change permissions / ownership in an isolated user namespace
# necessary for rootless container set up - 27 specific to mariadb
podman unshare chown 27:27 mydb

# verify mapping
podman unshare cat /proc/self/uid_map

# running the container
podman search mariadb | less # select image to pull
podman pull docker.io/library/mariadb:latest
podman images # verify
podman run --rm -it --entrypoint /bin/sh docker.io/library/mariadb # open interactive shell with the container to check filepath
cd /var/lib/
ls 

podman run -d -p 3206:3206 --name mydb -v /home/lisa/mydb:/var/lib/mysql:Z -e MYSQL_ROOT_PASSWORD=password docker.io/library/mariadb
podman ps -a

# compare selinux settings
ls -Z mydb
podman exec -it mydb sh # access the container
ls -Z /var/lib/mysql

# create a systemd service file for mydb - this is for a specific user
mkdir -p .config/systemd/user/
cd .config/systemd/user/
podman generate systemd --name mydb --files --new

# .service file for system-wide container
/etc/systemd/system/ # this is where other .service files are created

ls 
container-mydb.service

# move the service file to systemd directory
mv container-mydb.service /etc/systemd/system/

# enable this new service so that it is registered with systemd
systemctl --user daemon-reload
systemctl --user enable --now container-mydb.service
# Created symlink /home/lisa/.config/systemd/user/default.target.wants/container-mydb.service → /home/lisa/.config/systemd/user/container-mydb.service.

# reboot the host server

sudo -i
ps faux | less
/lisa
# check for a child of the conmon main process with mariadb declared - proof this is working!

# systemd files for root user 
/etc/containers/systemd/

# systemd files for rootless (user-specific) container
/.config/containers/systemd/

# create a mydb.container unit file
cat ~/.config/containers/systemd/mydb.container


## skopeo

# command line tool used to interact with container registries directly without pulling or running containers

skopeo inspect docker://docker.io/library/nginx:latest

