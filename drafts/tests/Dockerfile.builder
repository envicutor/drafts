FROM nestybox/ubuntu-jammy-docker

# apt update, apt upgrade, install xz-utils
RUN apt update && apt upgrade && apt-get install -y xz-utils

# install nix
RUN /bin/bash -c "sh <(curl -L https://nixos.org/nix/install) --daemon --yes" && systemctl enable nix-daemon.service

# build runner container Docker image
COPY ./Dockerfile.runner /runner
RUN cd /runner && docker build -t runner --file Dockerfile.runner .
