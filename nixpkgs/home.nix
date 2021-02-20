{ config, pkgs, ... }:

{

  imports = [
    # system dependent variables (home.{username,homeDirectory}).
    ./home-config.nix
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

    # Python
    python2
    python3

    # JavaScript
    nodejs
    nodePackages.npm

    # Bash
    shellcheck

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
      cmane = "commit --amend --no-edit";
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
}