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
  };

  outputs = inputs@{ self, flake-utils, nixpkgs, home-manager, nixpkgs-stable, nixpkgs-master, ... }:
    let
      nixpkgsOverlay = self: super: {
        stable = nixpkgs-stable.legacyPackages.${super.system};
        master = nixpkgs-master.legacyPackages.${super.system};
      };

      # This fix is required while waiting for https://github.com/NixOS/nixpkgs/pull/159516
      ipythonOverlay = self: super: {
        azure-cli = super.stable.azure-cli;
        docker-compose = super.stable.docker-compose;
      };

      # While waiting for nixpkgs PR 160410
      podmanOverlay = self: super: {
        podman = super.master.podman;
      };

      luaLanguageServerOverlay = import ./overlays/sumneko-lua-language-server.nix;
      omnisharpOverlay = import ./overlays/omnisharp-roslyn.nix;
      azureFunctionCoreToolsOverlay = import ./overlays/azure-functions-core-tools.nix;

      overlays = [
        (import ./spotify.nix)
        nixpkgsOverlay
        podmanOverlay
        ipythonOverlay
        luaLanguageServerOverlay
        omnisharpOverlay
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
                  nixpkgs.config.allowUnfree = true;
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
