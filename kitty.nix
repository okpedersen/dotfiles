{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    themeFile = "tokyo_night_storm";
    settings = {
      macos_option_as_alt = "left";
    };
  };
}
