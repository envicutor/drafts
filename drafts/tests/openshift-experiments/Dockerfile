FROM buildpack-deps:bookworm
RUN useradd -m envicutor && install -d -m755 -o envicutor -g envicutor /nix
USER envicutor
RUN /bin/bash -c "curl -L https://nixos.org/nix/install | sh"
CMD ["/bin/bash"]
