FROM nixos/nix:2.18.9
SHELL ["/root/.nix-profile/bin/bash", "-c"]
RUN nix-env -iA nixpkgs.rsync

RUN echo "cache invalidation!"
# Sync from cache to /nix if cache is not empty
RUN --mount=type=cache,target=/opt/mounted-cache [ -n "$(ls -A /opt/mounted-cache)" ] && rsync -av --delete /opt/mounted-cache/ /nix/ || echo "Mounted-cache is empty"
RUN nix-env -iA nixpkgs.python3 nixpkgs.cowsay && echo "yoooo nice!!!!!!"
# Sync from /nix back to cache
RUN --mount=type=cache,target=/opt/mounted-cache rsync -av --delete /nix/ /opt/mounted-cache/
