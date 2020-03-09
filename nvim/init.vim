" General configuration {{{

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

" python host progs
let g:python_host_prog="/usr/local/bin/python2.7"
let g:python3_host_prog="/usr/local/bin/python3.7"

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

Plug 'junegunn/vim-peekaboo'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'

Plug 'easymotion/vim-easymotion'

" git
Plug 'tpope/vim-fugitive'

Plug 'raimondi/delimitMate'

" Ale
Plug 'w0rp/ale'

" tmux
Plug 'christoomey/vim-tmux-navigator'

" colorscheme
Plug 'chriskempson/base16-vim'

Plug 'scrooloose/nerdtree'
call plug#end()
"}}}

" colorscheme
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Plugin configuration {{{

" vim-airline
let g:airline#extensions#tabline#enabled = 1

" vim-easymotion
let g:EasyMotion_do_mapping = 0 " disable default mapping

map <Leader>f <Plug>(easymotion-f)
map <Leader>F <Plug>(easymotion-F)
nmap <Leader>f <Plug>(easymotion-overwin-f)
nmap <Leader>F <Plug>(easymotion-overwin-f)

map <Leader>t <Plug>(easymotion-t)
map <Leader>T <Plug>(easymotion-T)

map <Leader>w <Plug>(easymotion-w)
map <Leader>W <Plug>(easymotion-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

map <Leader>e <Plug>(easymotion-e)
map <Leader>E <Plug>(easymotion-E)
map <Leader>ge <Plug>(easymotion-ge)
map <Leader>gE <Plug>(easymotion-gE)

map <Leader>n <Plug>(easymotion-n)
map <Leader>N <Plug>(easymotion-N)

map <Leader>j <Plug>(easymotion-sol-j)
map <Leader>k <Plug>(easymotion-sol-k)
nmap <Leader>j <Plug>(easymotion-overwin-line)
nmap <Leader>k <Plug>(easymotion-overwin-line)

" delimitMate
let g:delimitMate_expand_cr = 1		 
let g:delimitMate_expand_space = 0
let g:delimitMate_smart_matchpairs = 1
let g:delimitMate_balance_matchpairs = 1

" ale
let g:ale_echo_msg_format = '%code: %%linter% [%severity%] %s'

" NERDTree
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
map <Leader>n :NERDTreeFind<CR>

" }}}


" Language specific commands {{{

augroup lang_viml
  autocmd!
  autocmd Filetype python setlocal tabstop=4|setlocal shiftwidth=4| set expandtab
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
