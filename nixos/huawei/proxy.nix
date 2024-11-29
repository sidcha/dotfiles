{ config, lib, pkgs, ... }:

{
  # Add cntlm to system packages
  environment.systemPackages = [ pkgs.cntlm ];

  # Configure cntlm
  services.cntlm = {
    enable = true;
    username = "s00832113";
    domain = "china";
    proxy = [
      "proxy.huawei.com:8080"
    ];
    extraConfig = ''
      Listen 0.0.0.0:3128
    '';
    noproxy = [
      "127.0.0.*"
      "localhost"
      "10.204.62.*"
      "10.221.117.*"
      "100.93.48.*"
      "*.huawei.com"
      "*.inhuawei.com"
      # DNS servers
      "7.182.30.40"
      "7.182.30.38"
      "10.125.30.25"
      # lab hosts
      "10.206.133.93"
      "10.206.133.54"
      "virt.ict-lab.rnd.huawei.com"
    ];
  };

  # Create cntlm user and group
  users = {
    users.cntlm.group = "cntlm";
    groups.cntlm = {};
  };

  # Environment
  environment.sessionVariables = {
    cntlm_host = "127.0.0.1";
    cntlm_port = "3128";
    cntlm_proxy = "127.0.0.1:3128";
    NOTE_TLS_REJECT_UNAUTHORIZED = "0";
  };

  # Add huawei certificates obtained from Windows to root of trust
  security.pki.certificates = [
    (builtins.readFile ./root-ca/Huawei-BPIT-Root-CA.pem)
    (builtins.readFile ./root-ca/Huawei-CA.pem)
    (builtins.readFile ./root-ca/Huawei-IT-Mini-Root-CA.pem)
    (builtins.readFile ./root-ca/Huawei-IT-Root-CA.pem)
    (builtins.readFile ./root-ca/Huawei-Web-Secure-Internet-Gateway-CA.pem)
    (builtins.readFile ./root-ca/HWIT-Enterprise-CA.pem)
  ];
}
