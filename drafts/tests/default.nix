{ pkgs ? import <nixpkgs> {} }:
let
  compileScript = pkgs.writeShellScript "compile.sh" (import ./cutor.nix pkgs).compileScript;
  runScript = pkgs.writeShellScript "run.sh" (import ./cutor.nix pkgs).runScript;
in
  {
    inherit compileScript runScript;
    compileDependencies = (rootPaths: "${pkgs.closureInfo {inherit rootPaths;}}/store-paths") ([compileScript]);
    runDependencies = (rootPaths: "${pkgs.closureInfo {inherit rootPaths;}}/store-paths") ([runScript]);
  }
