{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/06278c77b5d162e62df170fec307e83f1812d94b.tar.gz") {} }:
let
  cln-m1 = pkgs.stdenv.mkDerivation {    # this line causes an error
    name = "cln-m1x";
    src = pkgs.fetchurl {
      url = "https://www.gsinac.de/CLN/cln-1.3.6.tar.bz2";
    };    # I also want to pass some flags to "configure" here
  };
  cln-m2 = pkgs.stdenv.mkDerivation {    # this line causes an error
    name = "cln-m2x";
    src = pkgs.fetchurl {
      url = "https://www.gsinac.de/CLN/cln-1.3.6.tar.bz2";
    };    # I also want to pass some flags to "configure" here
  };
  cln-m3 = pkgs.stdenv.mkDerivation {    # this line causes an error
    name = "cln-m3";
    src = pkgs.fetchurl {
      url = "https://www.gssinac.de/CLN/cln-1.3.6.tar.bz2";
    };    # I also want to pass some flags to "configure" here
  };
  cln-m4 = pkgs.stdenv.mkDerivation {    # this line causes an error
    name = "cln-m4";
    src = pkgs.fetchurl {
      url = "https://www.gsssinac.de/CLN/cln-1.3.6.tar.bz2";
    };    # I also want to pass some flags to "configure" here
  };
  cln-m5 = pkgs.stdenv.mkDerivation {    # this line causes an error
    name = "cln-m5";
    src = pkgs.fetchurl {
      url = "https://www.gsssinacj.de/CLN/cln-1.3.6.tar.bz2";
    };    # I also want to pass some flags to "configure" here
  };
  cln-m6 = pkgs.stdenv.mkDerivation {    # this line causes an error
    name = "cln-m6";
    src = pkgs.fetchurl {
      url = "https://www.gssssinacj.de/CLN/cln-1.3.6.tar.bz2";
    };    # I also want to pass some flags to "configure" here
  };
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # cln-m1
    # cln-m2
    # cln-m3
    # cln-m4
    # cln-m5
    # cln-m6
  ];
}
