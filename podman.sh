#!/bin/bash

sudo dnf install -y podman
sudo dnf install -y container-tools

podman --version

# check the list of registries podman uses to search for images
cat /etc/containers/registries.conf

# An array of host[:port] registries to try when pulling an unqualified image, in order.
unqualified-search-registries = ["registry.access.redhat.com", "registry.redhat.io", "docker.io"]

# check which images have been pulled and are available locally
podman images

# checks which images are available remotely and pull them to the local server
podman search {container-app} | less
podman pull {container-app}: latest

# check config and exposed ports
podman inspect {image-id}

# run a temporary container from the image and open an interactive shell
podman run --rm -it {image-id} /bin/bash

# specific options for this command
podman run --help

# once you pull an image it is available locally but you still need to create / run a container from the image
podman run -d --name mydb {image-ID}

# if container does not run correctly e.g. env variable required
podman logs {container-ID}


# mariadb example
podman run -d --name mydb -e MYSQL_ROOT_PASSWORD=password {image-name:image-tag}

# list all running containers
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

