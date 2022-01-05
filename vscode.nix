{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = (with pkgs.vscode-extensions; [
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "vscode-neovim";
      publisher = "asvetliakov";
      version = "0.0.82";
      sha256 = "YUlygCPleF+/Ttyd2PeebAoZkcAhFmatbHi1nd6XwJ0=";
    }];
    userSettings = {
      vscode-neovim.neovimExecutablePaths.darwin = "${pkgs.neovim}/bin/nvim";
      vscode-neovim.neovimInitPath = "~/.config/nvim/init.vim";
    };
  };
}
