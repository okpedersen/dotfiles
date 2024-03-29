{ pkgs, ... }:
let
  dotnetSdks = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_6_0
      sdk_7_0
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
    dapr-cli
    k6

    dotnetSdks
    spotify

    # docker
    docker
    docker-compose
    colima

    podman # TODO: Handle config in ~/.config/containers/containers.conf
    qemu
    gvproxy

    # pandoc with pdf output
    pandoc
    texlive.combined.scheme-small

    # economy/ledger
    ledger

    # Other
    fortune
  ];
}
