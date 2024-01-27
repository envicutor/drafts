FROM nixos/nix

COPY shell.nix cutor.nix .

# Warm up nix-shell
RUN nix-shell --command "sleep 0" && rm -rf shell.nix cutor.nix

# install nsjail (/root/.nix-profile/bin/nsjail)
RUN nix-channel --verbose --update && nix-env -iA nixpkgs.nsjail

CMD ["/bin/bash"]
