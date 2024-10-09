{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./huawei/proxy.nix
    ./huawei/configuration.nix
    ./home.nix
  ];

  # Don't change this.
  system.stateVersion = "24.05";

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # for doing "nix build" instead of "nix-build"
  nix.settings.experimental-features = "nix-command flakes";

  # Use the x systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # for vscode
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system. and enable the GNOME Desktop Environment.
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    desktopManager = {
      xterm.enable = false;
      gnome.enable = true;
    };
    displayManager = {
      gdm.enable = true;
    };
  };

  # Enable sound.
  hardware.pulseaudio.enable = true;

  networking.networkmanager.enable = true;

  users.users.sidcha = {
    description = "Siddharth Chandrasekaran";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.bash = {
    promptInit = ''
      # Provide a nice prompt if the terminal supports it.
      if [ "$TERM" != "dumb" ]; then
        PROMPT_COLOR="1;31m"
        ((UID)) && PROMPT_COLOR="1;32m"
        if [ -f ~/.name ]; then
          NAME=$(cat ~/.name)
        else
          NAME="$(hostname)"
        fi
        PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \W\a\]\u@\h: \W]\\$\[\033[0m\] "
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
    '';
    shellInit = ''
      if [ -f ~/.env ]; then
        source ~/.env
      fi
    '';
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}

