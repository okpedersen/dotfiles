{ config, ... }:
{
  xdg.configFile."karabiner".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/karabiner/configFiles";
}
