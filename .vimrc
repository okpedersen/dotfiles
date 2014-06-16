"====================================================
" General
"====================================================

" syntax highlighting
syntax on

" Enable fileype detection, load filtype settings, load indent files
filetype plugin indent on

" disable compatibility with vi
set nocompatible

" sane text files
set fileformat=unix
set encoding=utf-8

" change backspace behavior
set backspace=indent,eol,start

" correct tabs 
set tabstop=4
set shiftwidth=4
set softtabstop=4

" convert all typed tabs to spaces
set expandtab

" show cursor position all the time
set ruler

" colorcolumn
set colorcolumn=80

" splits open to the right and below
set splitbelow
set splitright

" display incomplete commands
set showcmd

" show line numbers
set number

" search
set hlsearch
set incsearch

" confirm save before exit
set confirm

"====================================================
" custom keyboard remaps
"====================================================

" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" easy split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" remap <leader> to ,
let mapleader = ","

" remove hlsearch until next search
nnoremap <Leader>/ :nohls<CR>

" fast save
nmap <leader>w :w<ESC>

" map <ESC> to jk
inoremap jk <ESC>
inoremap kj <ESC>

" autobraces by typing {}<CR>
inoremap {}<CR> {<CR>}<ESC>O


