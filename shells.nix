{ config, pkgs, ... }:
let
  path = "${builtins.toString ./.}/bin:$PATH:/usr/local/sbin";
in
{
  home.packages = with pkgs; [
    shellcheck
    bashInteractive
  ];

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "$(command -v nvim)";

      # Colorized man pages
      MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";

      # Zettelkasten
      ZK_FILES_DIR = "~/zettelkasten";

      PATH = path;

      # Azure CLI Telemetry opt-out
      FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT = 1;
    };
    initExtra = ''
      # don't put duplicate lines or lines starting with space in the history.
      # See bash(1) for more options
      HISTCONTROL=ignoreboth

      # From .sh_common_settings
      # set 256 color term for tmux
      TERM="xterm-256color"

      # Use vi mode
      set -o vi

      # Base16 Shell
      BASE16_SHELL="$HOME/.config/base16-shell/"
      [ -n "$PS1" ] && \
          [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
              eval "$("$BASE16_SHELL/profile_helper.sh")"

      # We have to source this to configure PATH correctly
      . ${pkgs.nix}/etc/profile.d/nix.sh
    '';

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
      ls = "${pkgs.exa}/bin/exa";
      l = "${pkgs.exa}/bin/exa -lahF";
    };
  };

  # TODO: Clean up zsh config
  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    sessionVariables = {
      EDITOR = "$(command -v nvim)";
      LANG = "en_US.UTF-8";

      # Colorized man pages
      MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";

      MANPATH = "/usr/local/man:$MANPATH";

      # Zettelkasten
      ZK_FILES_DIR = "~/zettelkasten";

      PATH = path;

      # Azure CLI Telemetry opt-out
      FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT = 1;
    };

    initExtra = ''
      # Base16 Shell
      BASE16_SHELL="$HOME/.config/base16-shell/"
      [ -n "$PS1" ] && \
          [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
              eval "$("$BASE16_SHELL/profile_helper.sh")"

      if [[ -a $HOME/.zsh_local_settings ]]; then
          source $HOME/.zsh_local_settings
      else
          echo "No local settings!";
      fi

      # We have to source this to configure PATH correctly
      . ${pkgs.nix}/etc/profile.d/nix.sh
    '';

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
      ls = "${pkgs.exa}/bin/exa";
      l = "${pkgs.exa}/bin/exa -lahF";
    };
  };
}
