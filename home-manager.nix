{ ... }:
let
  # system dependent variables
  sysConf = import ./home-config.nix {};
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home = {
    stateVersion = "21.03";
    username = sysConf.homeUsername;
    homeDirectory = sysConf.homeHomeDirectory;
  };
}
