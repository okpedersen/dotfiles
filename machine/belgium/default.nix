{ pkgs, ... }:
{
  imports = [
    ../../common-dev-tools.nix
  ];
  
  home.packages = with pkgs; [
    # pandoc with pdf output
    pandoc
    texlive.combined.scheme-small

    # economy/ledger
    ledger

    # Other
    fortune
  ];
}
