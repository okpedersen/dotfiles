" =================================
" General
" =================================

" basic settings
set nocompatible                "use Vim settings, not Vi
filetype plugin indent on       "load plugins and indent files
set t_Co=256                    "256 colors
syntax on                       "enable syntax highlightning
set encoding=utf8               "utf8-encoding
set fileformat=unix
set hidden                      "hide buffers when not displayed
set backspace=indent,eol,start  "allow backspacing in insert mode

" layout
set showcmd                     "show incomplete commands at the bottom
set showmode                    "show current mode at the bottom

set showbreak=....              "show .... to show linebreak
set nowrap                        "wrap lines
set linebreak                   "

set number                      "show line numbers

set laststatus=2                "show statusline
set cmdheight=2                 "two lines for cmds
set wildmenu                    "enable <CTRL>-n and <CTRL>-p to scroll matches
set wildmode=list:longest       "cmdline tab completion similar to bash

set colorcolumn=80              "column 80 is marked

" search
set hlsearch                    "highlight
set ignorecase                  "ignore case
set smartcase                   "don't ignore case when using uppercase letters
set incsearch                   "find the next match while typing

" confirm quit, and prompt to save, when exiting unsaved file
set confirm

" tab settings
set expandtab                   "tabs to spaces
set smarttab
set shiftwidth=4
set tabstop=4
set autoindent

" natural splits
set splitright
set splitbelow

"============================================
" custom keyboard remaps
"============================================

" Change leader to ','
let mapleader = ","

" set jk as escape button in insert mode
inoremap jk <ESC>

" reselect visualblock after indent/outdent
vnoremap > >gv
vnoremap < <gv

" easy split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" fast save
nnoremap <leader>w :w<CR>

" remove hlsearch until next search
nnoremap <silent> <Leader>/ :nohls<CR>

"==================================
" pathogen
"==================================

execute pathogen#infect()

"===========================================
" plugin configuration
"===========================================

set statusline=%f\                                  "filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}]     "file encoding
set statusline+=%y                                  "filetype
set statusline+=%m                                  "modified flag
set statusline+=%r                                  "read only flag

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set statusline+=\ %=                                "align left
set statusline+=Line:%l/%L[%p%%]                    "line X of Y [percent of file]
set statusline+=\ Col:%c                            "current column
set statusline+=\ Buf:%n                            "buffer number

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:sysntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = '✗'                  "Also applies to YCM
let g:syntastic_warning_symbol = '⚠'                "Also applies to YCM

" YCM
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_filetype_whitelist = {
    \ 'python'  : 1,
    \ 'cpp'     : 1,
    \ 'hpp'     : 1,
    \ 'c'       : 1,
    \ 'h'       : 1
    \}                  " whitelist only given languages
nnoremap <leader>jd :YcmCompleter GoTo<CR>
