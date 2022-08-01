{ pkgs, ... }:
{
  home.packages = with pkgs; [
    azure-cli
    azure-functions-core-tools
  ];

  home.sessionVariables.FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT = 1;

  # TODO: Add ~/.azure/config to nix
}
