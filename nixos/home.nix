{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users.sidcha = {
    home.stateVersion = "24.05"; # don't change this

    home.file.".config/vim".source = ../runcon/vim;
    home.file.".config/nvim".source = ../runcon/nvim;
    home.file.".config/tmux".source = ../runcon/tmux;
    home.file.".config/mutt".source = ../runcon/mutt;
    home.file.".config/git/personal.config".text = ''
      [user]
        name = Siddharth Chandrasekaran
        email = sidcha.dev@gmail.com
    '';
    home.file.".config/git/work.config".text = ''
      [user]
        name = Siddharth Chandrasekaran
	email = siddharth.chandrasekaran@huawei.com
    '';

    home.packages = with pkgs; [
      # common
      pass

      # dev-tools
      neovim
      gcc
      rustup
      ripgrep
      git
      tmux

      # GUI apps
      firefox
      vscode
      mattermost-desktop
    ];

    programs.bash.enable = true;
    programs.fzf.enable = true;
    programs.git = {
      enable = true;
      #userName = "Siddharth Chandrasekaran";
      #userEmail = "siddharth.chandrasekaran@huawei.com";
      aliases = {
        last = "diff HEAD^ HEAD";
        ll = "log --format=%h --abbrev=12 --oneline";
	staash = "stash --all";
        su = "submodule update --recursive";
      };
      extraConfig = {
        includeIf."gitdir:~/work/oss/".path = "~/.config/git/oss.config";
        includeIf."gitdir:~/work/".path = "~/.config/git/work.config";
	rerere.enabled = true;
	branch.sort = "-commiterdate";
        url."https://github.com/".insteadOf = [ "gh:" "github:" ];
        rebase.autoSquash = true;
        sendemail.confirm = "always";
        am.threeWay = true;
        color.ui = "auto";
        core.excludesfile = "~/.gitignore";
      };
    };
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
	fugitive
        fzf-vim
        seoul256-vim
        vim-surround 
	vim-sensible
	vim-fetch
	editorconfig-vim
        vim-buffergator
	vim-sneak
      ];
      settings = { ignorecase = true; };
      extraConfig = ''
        source ~/.config/vim/vimrc
      '';
    };
    programs.bash.initExtra = ''
      alias gg='rg --no-heading --line-number'
      alias gst='git status'
      alias gdf='git diff'
      alias gdfc='git diff --cached'
      alias ll='ls -la'
    '';

    home.sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      MUTT_CONFIG = "~/.config/mutt/muttrc";
    };
  };
}
