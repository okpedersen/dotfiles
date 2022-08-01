{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    theme = "Tokyo Night Storm";
    settings = {
      macos_option_as_alt = "left";
    };
  };
}
