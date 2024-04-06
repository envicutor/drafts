FROM buildpack-deps:bookworm
RUN useradd -u 1005760000 -m envicutor && install -d -m755 -o envicutor -g envicutor /nix
USER 1005760000
RUN /bin/bash -c "curl -L https://nixos.org/nix/install | sh"
CMD ["/bin/sleep", "infinity"]
