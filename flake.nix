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

    homeConfigurations."ole.pedersen" = home-manager.lib.homeManagerConfiguration {
      configuration = { imports = [ ./machine/belgium { nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay ]; }]; };
      system = "x86_64-darwin";
      username = "ole.pedersen";
      homeDirectory = "/Users/olekristianpedersen";
      stateVersion = "21.05";
    };
  };
}
