{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      macos_option_as_alt = "left";
    };
  };
}
