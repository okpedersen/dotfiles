{
  description = "Home configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager  = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs , home-manager, nix-darwin, ...}: {

    defaultPackage.x86_64-darwin = (nix-darwin.lib.darwinSystem {
      inputs = inputs;
      modules = [ ./darwin-bootstrap.nix ];
    }).system;

    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;


    homeConfigurations."ole.pedersen" = home-manager.lib.homeManagerConfiguration {
      configuration = { imports = [ ./machine/belgium { nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay ]; }]; };
      system = "x86_64-darwin";
      username = "ole.pedersen";
      homeDirectory = "/Users/olekristianpedersen";
      stateVersion = "21.05";
    };

    darwinConfigurations.bootstrap = nix-darwin.lib.darwinSystem {
      inputs = inputs;
      modules = [ ./darwin-bootstrap.nix ];
    };

    darwinConfigurations.belgium = nix-darwin.lib.darwinSystem {
      inputs = inputs;
      modules = [ 
        home-manager.darwinModules.home-manager
        ./darwin-configuration.nix 
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay ]; 
          home-manager.useGlobalPkgs = true;
          home-manager.users."ole.pedersen" = {
            imports = [ ./machine/belgium ];
          };
          users.users."ole.pedersen".home = "/Users/olekristianpedersen";
        }
      ];
    };

    homeConfigurations.docker = home-manager.lib.homeManagerConfiguration {
      configuration = { imports = [ ./minimal.nix ./neovim.nix { nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay ]; }]; };
      system = "x86_64-linux";
      username = "docker";
      homeDirectory = "/home/docker";
      stateVersion = "21.05";
    };
  };
}
