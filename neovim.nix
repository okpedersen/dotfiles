{ config, pkgs, ... }:
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  home.packages = with pkgs; [
    # Language servers for neovim
    nodePackages.vim-language-server
    nodePackages.bash-language-server
    nodePackages.pyright
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    withNodeJs = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [ ]);
    plugins = with pkgs.vimPlugins; [
      # Airline
      {
        plugin = vim-airline;
        config = "let g:airline#extensions#tabline#enabled = 1";
      }
      vim-airline-themes # TODO: check config
      {
        plugin = base16-vim;
        config = ''
          if filereadable(expand("~/.vimrc_background"))
            let base16colorspace=256
            source ~/.vimrc_background
          endif
        '';
      }

      # tpope plugins
      vim-abolish
      vim-repeat
      vim-surround
      vim-unimpaired
      vim-fugitive

      {
        plugin = delimitMate;
        config = ''
          let g:delimitMate_expand_cr = 1
          let g:delimitMate_expand_space = 0
          let g:delimitMate_smart_matchpairs = 1
          let g:delimitMate_balance_matchpairs = 1
        '';
      }

      fzf-vim
      fzfWrapper

      {
        plugin = nerdtree;
        config = ''
          let NERDTreeShowHidden=1
          let NERDTreeQuitOnOpen=1
          map <Leader>n :NERDTreeFind<CR>
        '';
      }

      {
        plugin = tmux-navigator;
        config = ''
          " add corresponding settings when using vim terminal
          tnoremap <C-h> <C-\><C-n><C-w>h
          tnoremap <C-j> <C-\><C-n><C-w>j
          tnoremap <C-k> <C-\><C-n><C-w>k
          tnoremap <C-l> <C-\><C-n><C-w>l
        '';
      }

      nvim-lspconfig
      {
        plugin = completion-nvim;
        config = ''
          let g:completion_matching_strategy_list=['exact', 'substring', 'fuzzy']
          let g:completion_enable_auto_paren = 1
        '';
      }

      {
        plugin = ale;
        config = ''
          let g:ale_echo_msg_format = '%code: %%linter% [%severity%] %s'
        '';
      }
    ];
    extraConfig = ''
      " General configuration {{{

      let g:uname = system("uname -a")
      let g:is_macos = g:uname =~ "Darwin"
      let g:is_wsl = g:uname =~ "Microsoft"

      set hidden " hide buffers when not displayed

      set nowrap " disable automatic wrapping

      set formatoptions-=ro " no automatic comment leader after <Enter> or 'o'/'O'

      " show line number of current line, but use relative numbers on other lines
      set number
      set relativenumber

      " search options
      set hlsearch   " highlight
      set ignorecase " ignore case
      set smartcase  " ... except when using uppercase letters
      set incsearch  " find the next match while typing

      " confirm quit, and prompt to save, when exiting unsaved file
      set confirm

      " predictable splits
      set splitright
      set splitbelow

      " default indent settings
      set expandtab    " tabs to spaces
      set tabstop=2    " width of <TAB>
      set shiftwidth=2 " length of a shift

      " don't print ins-completion-menu messages
      set shortmess+=c

      " avoid jumping when signs appear and disappear
      set signcolumn=yes

      " two lines for cmd
      set cmdheight=2

      " write swap file after 300ms of inactivity
      set updatetime=300

      " python host progs
      let g:loaded_python_provider = 0 " disable Python 2
      let g:python3_host_prog="~/.nix-profile/bin/nvim-python3"
      "}}}

      " Miscellaneous utilities {{{

      " reload vim config after save
      augroup reload_myvimrc
        autocmd!
        autocmd BufWritePost $MYVIMRC source $MYVIMRC
      augroup END

      " enable highlight of current line
      augroup enable_cursorline
        autocmd!
        autocmd BufEnter * set cursorline
        autocmd BufLeave * set nocursorline
      augroup END

      " terminal settings
      augroup terminal_settings
        autocmd!
        autocmd WinEnter,BufEnter term://* startinsert
        autocmd BufLeave term://* stopinsert
      augroup END
      " }}}

      " Custom keyboard remaps {{{

      " use space as map leader
      let mapleader=" "
      let maplocalleader="\\"

      " use jj as escape button in insert mode
      inoremap jk <ESC>

      " use <ESC> to escape insertion in terminal
      tnoremap <ESC> <C-\><C-n>

      " <Leader>/ to clear search highlights
      nnoremap <silent> <Leader>/ :nohls<CR>
      "}}}

      lua require("lsp")

      " Plugin configuration {{{
      " LSP
      set completeopt=menuone,noinsert,noselect
      " }}}


      " Language specific commands {{{
      augroup lang_viml
        autocmd!
        autocmd Filetype vim setlocal tabstop=2|setlocal shiftwidth=2| set expandtab
      augroup END

      augroup lang_python
        autocmd!
        autocmd Filetype python setlocal tabstop=4|setlocal shiftwidth=4| setlocal expandtab
        " allow expansion of triple quotes
        autocmd Filetype python let b:delimitMate_nesting_quotes = ['"']
      augroup END

      augroup lang_cpp
        autocmd!
        autocmd Filetype cpp setlocal tabstop=2|setlocal shiftwidth=2|setlocal expandtab
      augroup END

      " }}}
    '';
  };

  xdg.configFile."nvim/lua".source = ./nvim/lua;
}
