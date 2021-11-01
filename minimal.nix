{ pkgs, ... }:
{
  imports = [
    ./home-manager.nix
  ];

  home.packages = with pkgs; [
    nixpkgs-fmt
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
  ];

  programs.git = {
    enable = true;
    includes = [
      { path = "~/.gitlocalconfig"; }
    ];
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
      pf = "push --force-with-lease";
      ri = "rebase --interactive --autosquash";
      lp = "log -p";
      lg = "log --oneline --graph";
      lga = "log --oneline --graph --all";
      rp = "restore -p";
      rsp = "restore --staged -p";
    };
    extraConfig = {
      pull.ff = "only";
      diff = { tool = "nvimdiff"; };
      merge = { tool = "nvimdiff"; conflictstyle = "diff3"; };
      credential = if pkgs.stdenv.isDarwin then { helper = "osxkeychain"; } else { };
    };
  };
}
