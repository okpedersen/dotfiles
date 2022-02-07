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
      files.eol = "\n";
      editor.insertSpaces = true;
      editor.formatOnSave = true;
      editor.formatOnPaste = true;

      vscode-neovim.neovimExecutablePaths.darwin = "${pkgs.neovim}/bin/nvim";
      vscode-neovim.neovimInitPath = "~/.config/nvim/init.vim";

      "[csharp]" = {
        "editor.tabSize" = 4;
        "editor.defaultFormatter" = "ms-dotnettools.csharp";
      };
      csharp.semanticHighlighting.enabled = true;
      omnisharp.enableDecompilationSupport = true;
      omnisharp.enableAsyncCompletion = true;
      omnisharp.enableRoslynAnalyzers = true;
      omnisharp.enableImportCompletion = true;
      omnisharp.organizeImportsOnFormat = true;
    };
  };
}
