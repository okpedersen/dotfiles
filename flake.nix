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
  };

  outputs = inputs@{ self, nixpkgs , home-manager, ...}: {

    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    defaultPackage.x86_64-darwin = home-manager.defaultPackage.x86_64-darwin;

    homeConfigurations."ole.pedersen" = home-manager.lib.homeManagerConfiguration {
      configuration = {
        nixpkgs.config.allowUnfree = true;
        imports = [ ./machine/belgium { nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay (import ./spotify.nix)]; }];
      };
      system = "x86_64-darwin";
      username = "ole.pedersen";
      homeDirectory = "/Users/olekristianpedersen";
      stateVersion = "21.05";
    };

    homeConfigurations."ole.kristian.eidem.pedersen" = home-manager.lib.homeManagerConfiguration {
      configuration = {
        nixpkgs.config.allowUnfree = true;
        imports = [ ./machine/venezuela { nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay (import ./spotify.nix)]; }];
      };
      system = "x86_64-darwin";
      username = "ole.kristian.eidem.pedersen";
      homeDirectory = "/Users/ole.kristian.eidem.pedersen";
      stateVersion = "21.05";
    };

    belgium = self.homeConfigurations."ole.pedersen".activationPackage;

    homeConfigurations.docker = home-manager.lib.homeManagerConfiguration {
      configuration = { imports = [ ./minimal.nix ./neovim.nix { nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay ]; }]; };
      system = "x86_64-linux";
      username = "docker";
      homeDirectory = "/home/docker";
      stateVersion = "21.05";
    };
  };
}
