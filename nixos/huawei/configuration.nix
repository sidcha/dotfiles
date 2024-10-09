{ config, lib, pkgs, ... }:

{
  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  # set static IP for eth0, this IP is assigned for sidcha by IT.
  networking = {
    hostName = "hyperion";
    interfaces.eth0.ipv4.addresses = [{
      address = "10.206.133.93";
      prefixLength = 24;
    }];
    firewall = {
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 51840 ];
    };
    proxy = {
      default = "http://127.0.0.1:3128";
      noProxy = "127.0.0.1,localhost,huawei.com,10.206.133.93,10.206.133.54";
    };
  };
}
