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
    nixpkgs-netcoredbg.url = "github:SilverCoder/nixpkgs/ca3d39623c53420339f6b1c6bde016451b50f927";

    nvim-tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    # Used for home-manager darwin applications hack
    mkAlias = {
			url = "github:cdmistman/mkAlias";
			inputs.nixpkgs.follows = "nixpkgs";
		};
  };

  outputs = inputs@{ self, flake-utils, nixpkgs, home-manager, nixpkgs-stable, nixpkgs-master, nixpkgs-netcoredbg, ... }:
    let
      nixpkgsOverlay = self: super: {
        stable = nixpkgs-stable.legacyPackages.${super.system};
        master = nixpkgs-master.legacyPackages.${super.system};
        nixpkgs-netcoredbg = nixpkgs-netcoredbg.legacyPackages.${super.system};
      };

      poetryOverlay = self: super: {
        poetry = super.nixpkgs-stable.poetry;
      };

      netcoredbgOverlay = self: super: {
        netcoredbg = super.nixpkgs-netcoredbg.netcoredbg;
      };

      neovimOverlay = self: super: {
        myVimPlugins = {
          tokyonight = super.pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "tokyonight.nvim";
            version = "master";
            src = inputs.nvim-tokyonight;
          };
        };
      };

      mkAliasOverlay = self: super: {
        # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1468889352
        mkAlias = inputs.mkAlias.outputs.apps.${super.system}.default.program;
      };

      overlays = [
        (import ./spotify.nix)
        nixpkgsOverlay
        neovimOverlay
        netcoredbgOverlay
        mkAliasOverlay
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
                pkgs = nixpkgs.legacyPackages.${system};
                modules = [
                  {
                    # nixpkgs.config.allowUnfree = true;  # FIXME: https://github.com/nix-community/home-manager/issues/2942
                    nixpkgs.config.allowUnfreePredicate = (pkg: true);
                    nixpkgs.overlays = overlays;
                    imports = conf.imports;
                  }
                  {
                    home = {
                      username = conf.username;
                      homeDirectory = conf.homeDirectory;
                      stateVersion = "22.11";
                    };
                  }
                ];
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
