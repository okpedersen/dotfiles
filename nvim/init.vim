" vim:ts=2:sw=2:expandtab:foldmethod=marker:
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
if g:is_macos
  let g:python_host_prog="/usr/local/bin/python2.7"
  let g:python3_host_prog="/usr/local/bin/python3"
elseif is_wsl
  let g:python_host_prog="/usr/bin/python2.7"
  let g:python3_host_prog="/usr/bin/python3"
endif
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

" Plugin installation {{{
call plug#begin('~/.config/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" https://github.com/junegunn/vim-peekaboo/issues/74
" Plug 'junegunn/vim-peekaboo'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" git
Plug 'tpope/vim-fugitive'

Plug 'raimondi/delimitMate'

" vimwiki
Plug 'vimwiki/vimwiki'
Plug 'michal-h21/vim-zettel'

" LSP
Plug 'neovim/nvim-lsp'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'

" Ale
Plug 'w0rp/ale'

" tmux
Plug 'christoomey/vim-tmux-navigator'

" colorscheme
Plug 'chriskempson/base16-vim'

Plug 'scrooloose/nerdtree'
call plug#end()
"}}}

lua require("lsp")

" colorscheme
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Plugin configuration {{{

" vim-airline
let g:airline#extensions#tabline#enabled = 1

" delimitMate
let g:delimitMate_expand_cr = 1		 
let g:delimitMate_expand_space = 0
let g:delimitMate_smart_matchpairs = 1
let g:delimitMate_balance_matchpairs = 1

" ale
let g:ale_echo_msg_format = '%code: %%linter% [%severity%] %s'

" tmux navigator
" add corresponding settings when using vim terminal
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" CoC {{{
" }}}

" vimwiki/zettelkasten
let g:vimwiki_list = [{
  \ 'path': $ZK_FILES_DIR,
  \ 'syntax': 'markdown',
  \ 'ext': '.md'
  \ }]

let g:zettel_format = "%Y%m%d%H%M %title"

let g:zettel_fzf_command = "rg --column --line-number --ignore-case \
                           \--no-heading --color=always "


" NERDTree
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
map <Leader>n :NERDTreeFind<CR>


" LSP
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list=['exact', 'substring', 'fuzzy']
let g:completion_enable_auto_paren = 1

let g:diagnostic_insert_delay = 1
let g:diagnostic_show_sign = 1
let g:diagnostic_enable_virtual_text = 1

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
