FROM nixos/nix

# install nsjail (/root/.nix-profile/bin/nsjail)
RUN nix-channel --verbose --update && nix-env -iA nixpkgs.nsjail

CMD ["/bin/bash"]
