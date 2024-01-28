{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/4fddc9be4eaf195d631333908f2a454b03628ee5.tar.gz") {} }:
let
  # cln-m1 = pkgs.stdenv.mkDerivation {    # this line causes an error
  #   name = "cln-m1xx";
  #   src = pkgs.fetchurl {
  #     url = "https://www.gsinac.de/CLN/cln-aslkdj1.3.6.tar.bz2";
  #   };    # I also want to pass some flags to "configure" here
  # };
  # cln-m2 = pkgs.stdenv.mkDerivation {    # this line causes an error
  #   name = "cln-m2xx";
  #   src = pkgs.fetchurl {
  #     url = "https://asldkjwww.gsinac.de/CLN/cln-1.3.6.tar.bz2";
  #   };    # I also want to pass some flags to "configure" here
  # };
  # cln-m3 = pkgs.stdenv.mkDerivation {    # this line causes an error
  #   name = "cln-m3x";
  #   src = pkgs.fetchurl {
  #     url = "https://www.gssinaslkdjac.de/CLN/cln-1.3.6.tar.bz2";
  #   };    # I also want to pass some flags to "configure" here
  # };
  # cln-m4 = pkgs.stdenv.mkDerivation {    # this line causes an error
  #   name = "cln-m4x";
  #   src = pkgs.fetchurl {
  #     url = "https://www.gsssinac.deasdlkj/CLN/cln-1.3.6.tar.bz2";
  #   };    # I also want to pass some flags to "configure" here
  # };
  # cln-m5 = pkgs.stdenv.mkDerivation {    # this line causes an error
  #   name = "cln-m5x";
  #   src = pkgs.fetchurl {
  #     url = "https://www.gsssinaasdlkjcj.de/CLN/cln-1.3.6.tar.bz2";
  #   };    # I also want to pass some flags to "configure" here
  # };
  # cln-m6 = pkgs.stdenv.mkDerivation {    # this line causes an error
  #   name = "cln-m6x";
  #   src = pkgs.fetchurl {
  #     url = "https://www.gssssinacj.deasldkjaslkj/CLN/cln-1.3.6.tar.bz2";
  #   };    # I also want to pass some flags to "configure" here
  # };
  # compile_script = "
  # $PATH=${pkgs.gcc}/bin
  # ${pkgs.rustc}/bin/cargo build
  # ";
  # run_script = "${pkgs.rustc}/bin/cargo run";
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # python3
    # ghc
    # ruby
    rustc
    # cln-m1
    # cln-m2
    # cln-m3
    # cln-m4
    # cln-m5
    # cln-m6
  ];
}
