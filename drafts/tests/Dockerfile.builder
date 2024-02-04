FROM alpine:3.19.1

RUN apk update && apk add xz curl bash shadow docker

# install nix, nix-serve
RUN /bin/bash -c "sh <(curl -L https://nixos.org/nix/install) --daemon --yes" && \
  /root/.nix-profile/bin/nix-env -iA nixpkgs.nix-serve || \
  exit 1

# build runner container Docker image
COPY ./Dockerfile.runner /runner/
RUN dockerd & cd /runner && \
  sleep 2 && \
  docker build -t runner --file Dockerfile.runner . && \
  kill $(cat /var/run/docker.pid) && \
  kill $(cat /run/docker/containerd/containerd.pid) && \
  rm -f /var/run/docker.pid && \
  rm -f /run/docker/containerd/containerd.pid && \
  rm -rf -- /runner

# TODO: change /bin/bash to the builder program
# TODO: consider using systemd or separating the containers
CMD ["bash", "-c", "/root/.nix-profile/bin/nix-daemon & dockerd & /root/.nix-profile/bin/nix-serve --listen 0.0.0.0:8000 & /bin/sleep 2 && exec /bin/bash || exit 1"]
