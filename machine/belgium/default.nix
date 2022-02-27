{ pkgs, ... }:
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
