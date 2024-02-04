FROM alpine:3.19.1

# apt update, apt upgrade, install required packages for installing nix
RUN apk update && apk add xz curl bash shadow docker

# install nix
RUN /bin/bash -c "sh <(curl -L https://nixos.org/nix/install) --daemon --yes" || exit 1

# build runner container Docker image
COPY ./Dockerfile.runner /runner/
RUN dockerd & cd /runner && \
  sleep 2 && \
  docker build -t runner --file Dockerfile.runner . && \
  kill $(cat /var/run/docker.pid) && \
  kill $(cat /run/docker/containerd/containerd.pid) && \
  rm -rf -- /runner

# TODO: change /bin/bash to the builder program
CMD ["bash", "-c", "/root/.nix-profile/bin/nix-daemon & dockerd & /bin/sleep 0.5 && /bin/ps | /bin/grep -q nix-daemon && /bin/ps | /bin/grep -q dockerd && exec /bin/bash || exit 1"]
