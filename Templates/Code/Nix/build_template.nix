{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
}:

pkgs.dockerTools.buildImage {
  name = "curl";
  tag = "template";

  # fromImage = null;
  # fromImageName = null;
  # fromImageTag = "latest";
  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = [ pkgs.curl ];
    pathsToLink = [ "/bin" ];
  };

  runAsRoot = ''
    #!${pkgs.runtimeShell}
    mkdir -p /data
  '';

  config = {
    Cmd = [ "/bin/curl" ];
    WorkingDir = "/data";
    Volumes = { "/data" = { }; };
  };

  diskSize = 1024;
  buildVMMemorySize = 512;
}
