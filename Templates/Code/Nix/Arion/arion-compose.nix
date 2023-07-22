{
  project.name = "PROJECT_NAME";
  services.<PROJECT_NAME> = { pkgs, lib, ... }: {
    nixos.useSystemd = true;
    nixos.configuration.boot.tmp.useTmpfs = true;

    nixos.configuration = {
      services.<PROJECT_NAME>.enable = true;
    };

    # required for the service, arion tells you what is required
    service.capabilities.SYS_ADMIN = true;

    # required for network
    nixos.configuration.systemd.services.netdata.serviceConfig.AmbientCapabilities =
      lib.mkForce [ "CAP_NET_BIND_SERVICE" ];
    
    service.image = "alpine";

    # bind container local port to host port
    service.ports = [
      "8080:7777" # host:container
    ];
    
    #stop_signal = "SIGINT";
  };
}
