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
let g:python_host_prog="/home/okpedersen/virtualenvs/nvimpy2/bin/python2.7"
let g:python3_host_prog="/home/okpedersen/virtualenvs/nvimpy3/bin/python3.7"

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
inoremap jj <ESC>

" use <ESC> to escape insertion in terminal
tnoremap <ESC> <C-\><C-n>

" <Leader>/ to clear search highlights
nnoremap <silent> <Leader>/ :nohls<CR>
"}}}

" Plugin installation {{{
call plug#begin('~/.config/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-surround'

Plug 'easymotion/vim-easymotion'

" git
Plug 'tpope/vim-fugitive'

Plug 'raimondi/delimitMate'

Plug 'sheerun/vim-polyglot'

Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}

" cpp
" use superbo fork, due to no fix for clang >= 6.0.0 in zchee
"Plug 'zchee/deoplete-clang'
Plug 'superbo/deoplete-clang'
Plug 'Shougo/neoinclude.vim'

" python
Plug 'zchee/deoplete-jedi'

" julia
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do' : 'bash install.sh'}
Plug 'JuliaEditorSupport/julia-vim'

" latex
Plug 'lervag/vimtex', {'for' : 'tex'}

" Ale
Plug 'w0rp/ale'

" UltiSnips
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'chriskempson/base16-vim'

call plug#end()
"}}}

" colorscheme
let g:base16colorspace=256
colorscheme base16-classic-dark
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

" deoplete.nvim
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_debug = 1
let g:deoplete#auto_completion_start_length = 1

" deoplete-clangx

" deoplete-clang
"let g:deoplete#sources#clang#executable = '/usr/bin/clang'
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'

call deoplete#custom#var('omni', 'input_patterns', {
  \ 'tex': g:vimtex#re#deoplete
  \})


"vimtex
let g:vimtex_syntax_minted = [
      \ { 
      \   'lang' : 'c',
      \ },
      \ {
      \   'lang' : 'cpp',
      \   'environments' : ['cppcode', 'cppcode_test'],
      \ }
      \]
let g:vimtex_compiler_progname = 'nvr'
"let g:vimtex_view_general_viewer = 'okular'
"let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
"let g:vimtex_view_general_options_latexmk = '--unique'

let g:polyglot_disabled=['latex']

" ale
let g:ale_echo_msg_format = '%code: %%linter% [%severity%] %s'
let g:ale_linters_ignore = {
      \   'tex' : ['lacheck']
      \ }

" julia
let g:default_julia_version = '1.0'

" julia-vim (from polyglot)
let g:latex_to_unicode_auto = 1
let g:tex_flavor = 'latex'

" language server
"let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
\ 'julia': ['julia', '--startup-file=no', '--history-file=no', '-e', '
\   using LanguageServer;
\   server = LanguageServer.LanguageServerInstance(stdin, stdout, false);
\   server.runlinter = true;
\   run(server);
\ ']
\ }

"autocmd FileType julia setlocal omnifunc=LanguageClient#complete

" UltiSnips
let g:UltiSnipsSnippetDir="~/.config/nvim/UltiSnips"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

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

augroup lang_latex
  autocmd!
  autocmd Filetype tex setlocal tabstop=2|setlocal shiftwidth=2|setlocal expandtab
  autocmd Filetype tex setlocal wrap|setlocal breakindent
augroup END
" }}}
