{ config, pkgs, ... }:
{
  imports = [
    # system dependent variables (home.{username,homeDirectory}).
    ./home-config.nix
    # programs
    ./neovim.nix
    ./shells.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";

  home.packages = with pkgs; [
    # standard unix tools
    coreutils
    diffutils
    ed
    findutils
    gawk
    indent
    gnused
    gnutar
    which
    gnutls
    gnugrep
    gzip
    gnupatch
    less
    file
    perl
    rsync
    unzip
    procps # watch

    # CLI tools
    jq              # TODO: Install as program w/conf
    exa
    bat             # TODO: Install as program w/conf
    fd
    ripgrep
    tldr
    htop
    curl            # TODO: check vs curlFull
    inetutils
    tree            # For fzf

    # Python
    python2
    python3

    # JavaScript
    nodejs
    nodePackages.npm

    # Go
    go

    # Cloud and k8s
    doctl
    kubectl
    kubernetes-helm

    # Other development
    nodePackages.gitmoji-cli

    # pandoc with pdf output
    pandoc
    texlive.combined.scheme-small

    # Other
    fortune
  ];

  programs.git = {
    enable = true;
    userEmail = "okpedersen@gmail.com";
    userName = "Ole Kristian Pedersen";
    delta.enable = true;
    ignores = [
      "*.sw[op]"
    ];
    aliases = {
      co = "checkout";
      cob = "checkout -b";
      ap = "add -p";
      cm = "commit";
      cmm = "commit -m";
      cma = "commit --amend";
      cmane = "commit --amend --no-edit";
      d = "diff";
      ds = "diff --staged";
      puo = "!git push -u origin $(git branch --show-current)";
      ri = "rebase --interactive --autosquash";
      lp = "log -p";
      lg = "log --oneline --graph";
      lga = "log --oneline --graph --all";
    };
    extraConfig = {
      diff = { tool = "nvimdiff"; };
      merge = { tool = "nvimdiff"; conflictstyle = "diff3"; };
      credential = if pkgs.stdenv.isDarwin then { helper = "osxkeychain"; } else { };
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    sensibleOnTop = false;
    shell = "${pkgs.zsh}/bin/zsh";
    escapeTime = 10; # Recommended for neovim
    terminal = "tmux-256color"; # Recommended for neovim
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
      defaultCommand         = "${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git";
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d --hidden --follow --exclude .git";
      fileWidgetCommand      = "${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
      fileWidgetOptions = [ "--preview '${pkgs.bat}/bin/bat --color=always --style=numbers {} | head -500'" ];
  };
}
