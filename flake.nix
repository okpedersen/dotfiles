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

  outputs = inputs@{ self, nixpkgs , home-manager, ...}:
  let
    # This fix is required while waiting for https://github.com/NixOS/nixpkgs/pull/137870
    # to be merged and land in nixpkgs-unstable
    bs4Overlay = self: super:
      let
        lib = super.lib;
      in
      rec {
        python39 = super.python39.override {
          packageOverrides = self: super: {
            beautifulsoup4 = super.beautifulsoup4.overrideAttrs (old: {
              propagatedBuildInputs = lib.remove super.lxml old.propagatedBuildInputs;
            });
          };
        };
        python39Packages = python39.pkgs;
      };
    # Dirty hack reversing https://github.com/NixOS/nixpkgs/pull/137912
    # Needed until https://github.com/NixOS/nixpkgs/pull/139482 reaches nixpkgs-unstable
    vscodeOverlay = self: super: {
      vscode = super.vscode.overrideAttrs (oldAttrs: { postPatch = "";});
    };

  in
  {

    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    defaultPackage.x86_64-darwin = home-manager.defaultPackage.x86_64-darwin;

    homeConfigurations."ole.pedersen" = home-manager.lib.homeManagerConfiguration {
      configuration = {
        nixpkgs.config.allowUnfree = true;
        imports = [ ./machine/belgium { nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay (import ./spotify.nix) bs4Overlay vscodeOverlay ]; }];
      };
      system = "x86_64-darwin";
      username = "ole.pedersen";
      homeDirectory = "/Users/olekristianpedersen";
      stateVersion = "21.05";
    };

    homeConfigurations."ole.kristian.eidem.pedersen" = home-manager.lib.homeManagerConfiguration {
      configuration = {
        nixpkgs.config.allowUnfree = true;
        imports = [ ./machine/venezuela { nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay (import ./spotify.nix) bs4Overlay vscodeOverlay ]; }];
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
