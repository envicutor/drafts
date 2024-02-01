pkgs:
{
  compileScript = "${pkgs.rustc} --version";
  runScript = "${pkgs.python3} --version";
}
