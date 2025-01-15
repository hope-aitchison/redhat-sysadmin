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



## Using containerfile

## Systemd integration