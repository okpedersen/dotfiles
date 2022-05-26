{ pkgs, ... }:
let
  sdk31and50 = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_5_0
      sdk_3_1
    ];
in
{
  imports = [
    ../../common-dev-tools.nix
    ../../karabiner
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
    go-bindata
    sdk31and50
  ];
}
