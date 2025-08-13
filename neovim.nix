{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs;
  builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
  ++
  [
    # Language servers for neovim
    nodePackages.vim-language-server
    nodePackages.bash-language-server
    pyright
    nodePackages.yaml-language-server
    nodePackages.typescript
    nodePackages.typescript-language-server
    terraform-ls
    nixd
    lua-language-server
    omnisharp-roslyn
    gopls
    jsonnet-language-server
    rust-analyzer

    tinymist # Typst LSP

    # Debuggers
    netcoredbg

    # Other
    pngpaste # for img-clip-nvim
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [ ]);
  };

  # Use outOfStoreSymlink to link entire nvim config for live editing
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
}
