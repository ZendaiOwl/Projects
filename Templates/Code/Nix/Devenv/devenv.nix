{ pkgs, ... }: {
  env.GREET = "glitch";

  packages = [ pkgs.git ];

  enterShell = "echo hello $GREET";
}
