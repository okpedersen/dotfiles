{ pkgs, ... }: {
  # Required for multi-user installs
  services.nix-daemon.enable = true;
  # From the Determinate Nix installer
  nix.settings = {
    bash-prompt-prefix = "(nix:$name)\040";
    extra-nix-path = "nixpkgs=flake:nixpkgs";
    experimental-features = "nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;


  # Nix-darwin fixes /etc/zsh files
  # TODO: Some more options should probably be set here
  programs.zsh.enable = true;

  # https://github.com/LnL7/nix-darwin/issues/682
  users.users.olekristian.home = "/Users/olekristian";

  security.pam.enableSudoTouchIdAuth = true;

  homebrew = {
    enable = true;
    global = {
      autoUpdate = false;
    };
    onActivation.cleanup = "zap";
    brews = [
       "dashlane/tap/dashlane-cli"
    ];
    casks = [
      {
        name = "spotify";
      }
    ];
    masApps = {
      # Removal of App Store apps must be done manually
      # First time installations require manual installation in the App Store

      # TODO: config managed by a plist
      "Velja" = 1607635845;
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.olekristian = { pkgs, ... }: {
    home.stateVersion = "23.05";

    imports = [
      ../../common-dev-tools.nix
      ../../firefox.nix
    ];

    # TODO:
    #targets.darwin.defaults = {
    #  "com.apple.dock" = {
    #    # Changes here requires "killall Dock" to be run after switching
    #    expose-group-apps = true;
    #    autohide = true;
    #    static-only = true;
    #  };
    #};

    home.packages = with pkgs; [
      k6

      docker
      docker-buildx
      docker-compose
      colima

      # podman # TODO: Handle config in ~/.config/containers/containers.conf
      # qemu
      # gvproxy

      # pandoc with pdf output
      pandoc
      texlive.combined.scheme-small
    ];
  };
}
