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

podman inspect {image-id}

# run a temporary container from the image and open an interactive shell
podman run --rm -it {image-id} /bin/bash

# specific options for this command
podman run --help

