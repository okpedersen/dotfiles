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

  outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, nixpkgs-stable, nixpkgs-master, nixpkgs-netcoredbg, nixpkgs-omnisharp, ... }:
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

      neovimOverlay = self: super: {
        myVimPlugins = {
          tokyonight = super.pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = "tokyonight.nvim";
            version = "master";
            src = inputs.nvim-tokyonight;
          };
        };
      };

      # https://github.com/OmniSharp/omnisharp-roslyn/issues/2574
      omnisharpOverlay = self: super: {
        omnisharp-roslyn = super.nixpkgs-omnisharp.omnisharp-roslyn;
      };

      mkAliasOverlay = self: super: {
        # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1468889352
        mkAlias = inputs.mkAlias.outputs.apps.${super.system}.default.program;
      };

      overlays = [
        #(import ./spotify.nix)
        nixpkgsOverlay
        neovimOverlay
        netcoredbgOverlay
        mkAliasOverlay
        omnisharpOverlay
      ];
    in
    {
      darwinConfigurations."bekk-mac-3199" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = overlays;
          }
          ./machine/m3/default.nix
        ];
      };
    };
}
