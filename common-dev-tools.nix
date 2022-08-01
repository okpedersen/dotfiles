{ pkgs, stdenv, ... }:
let
  nodejs = pkgs.nodejs;
  npmPkgs = import ./npmPkgs { inherit pkgs nodejs stdenv; };
in
{
  imports = [
    ./neovim.nix
    ./shells.nix
    ./minimal.nix
    ./vscode.nix
    ./kitty.nix
    ./azure.nix
  ];
  home.packages = with pkgs; [
    # CLI tools
    jq # TODO: Install as program w/conf
    exa
    bat # TODO: Install as program w/conf
    fd
    ripgrep
    tldr
    htop
    curl # TODO: check vs curlFull
    inetutils
    tree # For fzf
    entr
    procps # watch
    httpie

    # Python
    python2
    python3
    poetry

    # JavaScript
    nodejs
    nodePackages.npm

    # Go
    go

    # Cloud and k8s
    doctl
    kubectl
    kubernetes-helm
    terraform

    # Other development
    nodePackages.gitmoji-cli
  ];

  programs.tmux = {
    enable = true;
    clock24 = true;
    sensibleOnTop = false;
    shell = "${pkgs.zsh}/bin/zsh";
    escapeTime = 10; # Recommended for neovim
    terminal = "xterm-256color"; # Gives warnings in neovim, but fixes the 'clear' issue without messing with terminfo & tic
    historyLimit = 20000;
    extraConfig = ''
      setw -g monitor-activity on
      set -g visual-activity on
      set -g mode-keys vi
      set -g focus-events on


      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      bind-key r source-file ~/.tmux.conf \; display-message "tmux conf reloaded"

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
      bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
      bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
      bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
      bind-key -n C-\\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
      bind-key -T copy-mode-vi C-h select-pane -L
      bind-key -T copy-mode-vi C-j select-pane -D
      bind-key -T copy-mode-vi C-k select-pane -U
      bind-key -T copy-mode-vi C-l select-pane -R
      bind-key -T copy-mode-vi C-\\ select-pane -l
    '';
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # Use fd for fzf
    defaultCommand = "${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git";
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d --hidden --follow --exclude .git";
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    fileWidgetOptions = [ "--preview '${pkgs.bat}/bin/bat --color=always --style=numbers {} | head -500'" ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    # TODO: Check nix-direnv docs for disabling garbage collection
    nix-direnv.enable = true;
  };
}
