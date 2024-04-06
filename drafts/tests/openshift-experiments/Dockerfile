FROM buildpack-deps:bookworm
RUN useradd -u 1005760000 -m envicutor && install -d -m755 -o envicutor -g envicutor /nix
USER 1005760000
RUN /bin/bash -c "curl -L https://nixos.org/nix/install | sh"
RUN /bin/bash -c 'time /home/envicutor/.nix-profile/bin/nix-shell -p ghc --run "sleep 0"'
RUN /bin/bash -c 'time /bin/sleep 0'
CMD ["/bin/sleep", "infinity"]
