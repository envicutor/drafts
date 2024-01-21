{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    (import ./cutor.nix { inherit pkgs; })
  ];
}
