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
    nixpkgs-omnisharp.url = "github:NixOS/nixpkgs/bad8fbc216f12c5b79a83f3ca86a40c22ef5cf21";

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-services = {
      url = "github:homebrew/homebrew-services";
      flake = false;
    };
    dashlane-tap = {
      url = "github:dashlane/homebrew-tap";
      flake = false;
    };

    nur.url = "github:nix-community/NUR";

    # Used for home-manager darwin applications hack
    mkAlias = {
      url = "github:reckenrode/mkAlias";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, nur, nixpkgs-stable, nixpkgs-master, nixpkgs-netcoredbg, nixpkgs-omnisharp, ... }:
    let
      nixpkgsOverlay = self: super: {
        stable = nixpkgs-stable.legacyPackages.${super.system};
        master = nixpkgs-master.legacyPackages.${super.system};
        nixpkgs-netcoredbg = nixpkgs-netcoredbg.legacyPackages.${super.system};
        nixpkgs-omnisharp = nixpkgs-omnisharp.legacyPackages.${super.system};
      };

      netcoredbgOverlay = self: super: {
        netcoredbg = super.nixpkgs-netcoredbg.netcoredbg;
      };

      # https://github.com/OmniSharp/omnisharp-roslyn/issues/2574
      omnisharpOverlay = self: super: {
        omnisharp-roslyn = super.nixpkgs-omnisharp.omnisharp-roslyn;
      };

      mkAliasOverlay = self: super: {
        # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1468889352
        mkAlias = inputs.mkAlias.outputs.apps.${super.system}.default.program;
      };

      nixpkgsMasterOverlay = self: super: {
        # https://nixpk.gs/pr-tracker.html?pr=454842
        firefox = super.master.firefox;
        firefox-devedition = super.master.firefox-devedition;
      };

      overlays = [
        nur.overlays.default
        #(import ./spotify.nix)
        nixpkgsOverlay
        netcoredbgOverlay
        mkAliasOverlay
        omnisharpOverlay
        nixpkgsMasterOverlay
      ];
    in
    {
      darwinConfigurations."bekk-mac-3199" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          {
            system.stateVersion = 5;
          }
          home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = overlays;
          }
          inputs.nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "olekristian";
              taps = {
                "homebrew/homebrew-core" = inputs.homebrew-core;
                "homebrew/homebrew-cask" = inputs.homebrew-cask;
                "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                "homebrew/homebrew-services" = inputs.homebrew-services;
                "dashlane/tap" = inputs.dashlane-tap;
              };
              mutableTaps = true;
            };
          }
          {
            nix.registry.unstable = {
              from = { id = "unstable"; type = "indirect"; };
              flake = nixpkgs;
            };
          }
          ./machine/m3/default.nix
        ];
      };
    };
}
