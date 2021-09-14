{ pkgs, ... }:
let
  sdk31and50 = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_5_0 sdk_3_1
    ];
in
{
  imports = [
    ../../common-dev-tools.nix
  ];

  targets.darwin.defaults = {
    "com.apple.dock" = {
      # Changes here requires "killall Dock" to be run after switching
      expose-group-apps = true;
      autohide = true;
      static-only = true;
    };
  };

  home.packages = with pkgs; [
    sdk31and50
  ];
}
