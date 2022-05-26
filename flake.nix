{
  description = "Home configuration";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-podman.url = "github:nixos/nixpkgs/40caba20b3edb204e1ac42d99e4f847ef1196417"; # nixpkgs before podman 4.0.3 -> 4.1.0
  };

  outputs = inputs@{ self, flake-utils, nixpkgs, home-manager, nixpkgs-stable, nixpkgs-master, nixpkgs-podman, ... }:
    let
      nixpkgsOverlay = self: super: {
        stable = nixpkgs-stable.legacyPackages.${super.system};
        master = nixpkgs-master.legacyPackages.${super.system};
        nixpkgs-podman = nixpkgs-podman.legacyPackages.${super.system};
      };

      # FIXME: While waiting for SDK 10.13 (https://github.com/NixOS/nixpkgs/issues/101229)
      podmanOverlay = self: super: {
        podman = super.nixpkgs-podman.podman;
      };

      # TODO: azure-function-core-tools in nixpkgs does not support darwin
      azureFunctionCoreToolsOverlay = import ./overlays/azure-functions-core-tools.nix;

      overlays = [
        (import ./spotify.nix)
        nixpkgsOverlay
        podmanOverlay
        azureFunctionCoreToolsOverlay
      ];

      configurations = [
        {
          username = "ole.pedersen";
          imports = [ ./machine/belgium ];
          homeDirectory = "/Users/olekristianpedersen";
        }
        {
          username = "ole.kristian.eidem.pedersen";
          imports = [ ./machine/venezuela ];
          homeDirectory = "/Users/ole.kristian.eidem.pedersen";
        }
        {
          username = "docker";
          imports = [ ./minimal.nix ./neovim.nix ];
          homeDirectory = "/home/docker";
        }
      ];

    in
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system: {
        defaultPackage = home-manager.defaultPackage.${system};

        packages.homeConfigurations = (builtins.listToAttrs
          (map
            (conf: {
              name = "${conf.username}";
              value = home-manager.lib.homeManagerConfiguration {
                configuration = {
                  # nixpkgs.config.allowUnfree = true;  # FIXME: https://github.com/nix-community/home-manager/issues/2942
                  nixpkgs.config.allowUnfreePredicate = (pkg: true);
                  nixpkgs.overlays = overlays;
                  imports = conf.imports;
                };
                system = system;
                username = conf.username;
                homeDirectory = conf.homeDirectory;
                stateVersion = "21.05";
              };
            })
            configurations
          )
        );
      }) //
    {
      belgium = self.homeConfigurations."ole.pedersen".activationPackage;
    };
}
