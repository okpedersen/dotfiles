{ config, pkgs, ... }:
{
  nixpkgs.overlays = [
    (
      self: super:
      {
        neovim = super.neovim-unwrapped.overrideAttrs (old: {
          pname = "neovim";
          version = "master";
          src = super.fetchFromGitHub {
            owner = "neovim";
            repo = "neovim";
            rev = "f2fc44d50b511cb3cbffaf9ec4f37d1e7995aac7";
            sha256 = "1fk3wgs9pfqbcmzq0r8f86ya0idmcss7wiahgqzabcv8fis9gb9l";
          };
          buildInputs = old.buildInputs ++ [ pkgs.tree-sitter ];
        });
      }
    )
  ];

  imports = [
    # system dependent variables (home.{username,homeDirectory}).
    ./home-config.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";

  home.packages = with pkgs; [
    # standard unix tools
    coreutils
    diffutils
    ed
    findutils
    gawk
    indent
    gnused
    gnutar
    which
    gnutls
    gnugrep
    gzip
    gnupatch
    less
    file
    perl
    rsync
    unzip
    procps # watch

    # CLI tools
    jq              # TODO: Install as program w/conf
    exa
    bat             # TODO: Install as program w/conf
    fd
    ripgrep
    tldr
    htop
    curl            # TODO: check vs curlFull
    inetutils
    tree            # For fzf

    # Python
    python2
    python3

    # JavaScript
    nodejs
    nodePackages.npm

    # Bash
    shellcheck
    bash
    bashInteractive
    zsh

    # Go
    go

    # Cloud and k8s
    doctl
    kubectl
    kubernetes-helm

    # Language servers for neovim
    nodePackages.vim-language-server
    nodePackages.bash-language-server
    nodePackages.pyright

    # Other development
    nodePackages.gitmoji-cli

    # pandoc with pdf output
    pandoc
    texlive.combined.scheme-small

    # Other
    fortune
  ];

  programs.git = {
    enable = true;
    userEmail = "okpedersen@gmail.com";
    userName = "Ole Kristian Pedersen";
    delta.enable = true;
    ignores = [
      "*.sw[op]"
    ];
    aliases = {
      co = "checkout";
      cob = "checkout -b";
      ap = "add -p";
      cm = "commit";
      cmm = "commit -m";
      cma = "commit --amend";
      cmane = "commit --amend --no-edit";
      d = "diff";
      ds = "diff --staged";
      puo = "!git push -u origin $(git branch --show-current)";
      ri = "rebase --interactive --autosquash";
      lp = "log -p";
      lg = "log --oneline --graph";
      lga = "log --oneline --graph --all";
    };
    extraConfig = {
      diff = { tool = "nvimdiff"; };
      merge = { tool = "nvimdiff"; conflictstyle = "diff3"; };
      credential = if pkgs.stdenv.isDarwin then { helper = "osxkeychain"; } else { };
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    sensibleOnTop = false;
    shell = "${pkgs.zsh}/bin/zsh";
    escapeTime = 10; # Recommended for neovim
    terminal = "tmux-256color"; # Recommended for neovim
    extraConfig = ''
      setw -g monitor-activity on
      set -g visual-activity on
      set -g mode-keys vi
      set -g focus-events on


      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      bind-key r source-file ~/.tmux.conf \; display-message "tmux conf reloaded"

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
      bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
      bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
      bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
      bind-key -n C-\\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
      bind-key -T copy-mode-vi C-h select-pane -L
      bind-key -T copy-mode-vi C-j select-pane -D
      bind-key -T copy-mode-vi C-k select-pane -U
      bind-key -T copy-mode-vi C-l select-pane -R
      bind-key -T copy-mode-vi C-\\ select-pane -l
    '';
  };

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "$(command -v nvim)";

      # Colorized man pages
      MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";

      # Zettelkasten
      PATH = "~/dotfiles/bin:$PATH";
      ZK_FILES_DIR = "~/zettelkasten";
    };
    initExtra = ''
      # don't put duplicate lines or lines starting with space in the history.
      # See bash(1) for more options
      HISTCONTROL=ignoreboth

      # From .sh_common_settings
      # set 256 color term for tmux
      TERM="xterm-256color"

      # Use vi mode
      set -o vi

      # Base16 Shell
      BASE16_SHELL="$HOME/.config/base16-shell/"
      [ -n "$PS1" ] && \
          [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
              eval "$("$BASE16_SHELL/profile_helper.sh")"

      # We have to source this to configure PATH properly
      . "${pkgs.nix}/etc/profile.d/nix.sh"
    '';

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
      ls = "${pkgs.exa}/bin/exa";
      l = "${pkgs.exa}/bin/exa -lahF";
    };
  };

  # TODO: Clean up zsh config
  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    sessionVariables = {
      EDITOR = "$(command -v nvim)";
      LANG = "en_US.UTF-8";

      # Colorized man pages
      MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";

      MANPATH = "/usr/local/man:$MANPATH";

      # Zettelkasten
      ZK_FILES_DIR = "~/zettelkasten";

      PATH = "~/dotfiles/bin:$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games";
    };

    initExtra = ''
      # Base16 Shell
      BASE16_SHELL="$HOME/.config/base16-shell/"
      [ -n "$PS1" ] && \
          [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
              eval "$("$BASE16_SHELL/profile_helper.sh")"

      if [[ -a $HOME/.zsh_local_settings ]]; then
          source $HOME/.zsh_local_settings
      else
          echo "No local settings!";
      fi

      # We have to source this to configure PATH correctly
      . "${pkgs.nix}/etc/profile.d/nix.sh"
    '';

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
      ls = "${pkgs.exa}/bin/exa";
      l = "${pkgs.exa}/bin/exa -lahF";
    };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
      # Use fd for fzf
      defaultCommand         = "${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git";
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d --hidden --follow --exclude .git";
      fileWidgetCommand      = "${pkgs.fd}/bin/fd --type f --hidden --follow --exclude .git";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
      fileWidgetOptions = [ "--preview '${pkgs.bat}/bin/bat --color=always --style=numbers {} | head -500'" ];
  };



  programs.neovim = {
    enable = true;
    package = pkgs.neovim;
    withNodeJs = true;
    withPython = true;
    extraPythonPackages = (ps: with ps; []);
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
      let g:python_host_prog="~/.nix-profile/bin/nvim-python"
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
