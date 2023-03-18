{ pkgs, ... }:
let
  sdks = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_7_0
      sdk_6_0
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

  home.sessionVariables = {
    DOTNET_ROOT = "${sdks}";
  };

  home.packages = with pkgs; [
    go
    gopls
    delve
    go-bindata
    sdks
    yarn
    slack-cli
    k6
    kubelogin
    dbeaver
  ];
}
