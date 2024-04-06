FROM alpine:3.19.1
RUN apk update && apk add xz curl bash shadow
RUN /bin/bash -c "curl -L https://nixos.org/nix/install | sh"
CMD ["/bin/bash"]
