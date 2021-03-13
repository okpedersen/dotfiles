{ pkgs, nodejs, stdenv }:
let
  super = import ./composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
  self = super // {
    "azure-functions-core-tools@3" = super."azure-functions-core-tools-3.x.x";
  };
in self
