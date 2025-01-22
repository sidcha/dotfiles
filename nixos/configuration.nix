{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./huawei/proxy.nix
    ./huawei/configuration.nix
    ./home.nix
  ];

  # for doing "nix build" instead of "nix-build"
  nix.settings.experimental-features = "nix-command flakes";

  # Use the systemd-boot EFI boot loader.
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
    # Configure keymap in X11
    xkb.layout = "us";
    xkb.options = "eurosign:e,caps:escape";
    # Enable the GNOME Desktop Environment.
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
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  fonts.fontDir.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    gcc
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.bash.promptInit = ''
      # Source the git-prompt.sh script from the Nix store
      if [ -f "${pkgs.git}/share/git/contrib/completion/git-prompt.sh" ]; then
        source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh
      fi

      # Provide a nice prompt if the terminal supports it.
      if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
        PROMPT_COLOR="1;31m"
        ((UID)) && PROMPT_COLOR="1;32m"
        if [ -n "$INSIDE_EMACS" ]; then
          # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
          PS1='\[\033[$PROMPT_COLOR\][\u@\h: \W$(__git_ps1 " (%s)")]\\$\[\033[0m\] '
        else
          PS1='\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \W\a\]\u@\h: \W]$(__git_ps1 " (%s)")\\$\[\033[0m\] '
        fi
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
  '';

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
