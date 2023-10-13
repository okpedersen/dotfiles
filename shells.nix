{ config, pkgs, ... }:
let
  path = "${builtins.toString ./.}/bin:$PATH:/usr/local/sbin";
in
{
  home.packages = with pkgs; [
    shellcheck
    bashInteractive
  ];

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
      LANG = "en_US.UTF-8";
      PATH = path;
      MANPATH = "/usr/local/man:$MANPATH";
      # Colorized man pages
      MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
    };

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
      ls = "${pkgs.eza}/bin/eza";
      l = "${pkgs.eza}/bin/eza -lahF";
    };
  };
}
