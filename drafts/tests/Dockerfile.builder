FROM nestybox/ubuntu-jammy-docker

# apt update, apt upgrade, install required packages for installing nix
RUN apt update && apt upgrade -y && apt-get install -y xz-utils curl procps grep

# install nix
RUN /bin/bash -c "sh <(curl -L https://nixos.org/nix/install) --daemon --yes" || exit 1

# build runner container Docker image
COPY ./Dockerfile.runner /runner/
COPY ./nsjail /runner/nsjail
RUN dockerd & cd /runner && ls && \
  sleep 2 && \
  docker build -t runner --file Dockerfile.runner . && \
  kill $(cat /var/run/docker.pid) && \
  kill $(cat /run/docker/containerd/containerd.pid) && \
  rm -rf -- /runner

# TODO: change /bin/bash to the builder program
CMD ["bash", "-c", "/root/.nix-profile/bin/nix-daemon & /bin/sleep 0.5 && /bin/ps | /bin/grep -q nix-daemon && exec /bin/bash || exit 1"]
