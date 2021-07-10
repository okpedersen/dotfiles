{ config, pkgs, ... }:
{
  imports = [
    ./darwin-bootstrap.nix
  ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [];

  # Enable lorri, requires direnv
  services.lorri.enable = true;
}
 
