{
  description = "Home configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixpkgs-stable, nixpkgs-master, ... }:
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
    in
    {

      defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
      defaultPackage.x86_64-darwin = home-manager.defaultPackage.x86_64-darwin;

      homeConfigurations."ole.pedersen" = home-manager.lib.homeManagerConfiguration {
        configuration = {
          nixpkgs.config.allowUnfree = true;
          imports = [ ./machine/belgium { nixpkgs.overlays = [ (import ./spotify.nix) nixpkgsOverlay podmanOverlay ipythonOverlay luaLanguageServerOverlay omnisharpOverlay azureFunctionCoreToolsOverlay ]; } ];
        };
        system = "x86_64-darwin";
        username = "ole.pedersen";
        homeDirectory = "/Users/olekristianpedersen";
        stateVersion = "21.05";
      };

      homeConfigurations."ole.kristian.eidem.pedersen" = home-manager.lib.homeManagerConfiguration {
        configuration = {
          nixpkgs.config.allowUnfree = true;
          imports = [ ./machine/venezuela { nixpkgs.overlays = [ (import ./spotify.nix) nixpkgsOverlay podmanOverlay ipythonOverlay luaLanguageServerOverlay omnisharpOverlay azureFunctionCoreToolsOverlay ]; } ];
        };
        system = "x86_64-darwin";
        username = "ole.kristian.eidem.pedersen";
        homeDirectory = "/Users/ole.kristian.eidem.pedersen";
        stateVersion = "21.05";
      };

      belgium = self.homeConfigurations."ole.pedersen".activationPackage;

      homeConfigurations.docker = home-manager.lib.homeManagerConfiguration {
        configuration = { imports = [ ./minimal.nix ./neovim.nix { nixpkgs.overlays = [ ]; } ]; };
        system = "x86_64-linux";
        username = "docker";
        homeDirectory = "/home/docker";
        stateVersion = "21.05";
      };
    };
}
