" General configuration {{{

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
set laststatus=2

set nowrap                      "disable automatic wrapping
set linebreak                   "more natural linebreaking
set formatoptions=cq            "wrap comments (but not text), allow gq

set foldlevelstart=0            "fold everything when opening file

" show line number of current line, but use relative elsewhere
set number
set relativenumber

" search
set hlsearch                    "highlight
set ignorecase                  "ignore case
set smartcase                   "don't ignore case when using uppercase letters
set incsearch                   "find the next match while typing

" confirm quit, and prompt to save, when exiting unsaved file
set confirm

" default indent settings
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set autoindent

" natural splits
set splitright
set splitbelow
" }}}

" Custom keyboard remaps {{{

" change leaders
let mapleader=" "
let maplocalleader="\\"

" set jk as escape button in insert mode
inoremap jk <ESC>

"enable fast .vimrc editing
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" easer movement to begining/end of line
nnoremap H ^
nnoremap L $

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

" use very magic as default
nnoremap / /\v
nnoremap ? ?\v

" paste toggle with F2
nnoremap <silent> <F2> :set paste!<cr>

" remove hlsearch until next search
nnoremap <silent> <Leader>/ :nohls<CR>

" bind <leader>g to grep
nnoremap <leader>g :silent execute 'grep! -R ' .
            \ shellescape(expand("<cWORD>")) . ' .'<cr>:copen 10<cr>
" TODO: Add :cnext, :cprevious mappings

" }}}

" miscellaneous utilities {{{
augroup reload_vimrc " {{{
    autocmd!
    autocmd BufWritePost .vimrc source %
augroup END " }}}

augroup strip_trailing_whitespace " {{{
    autocmd!
    autocmd InsertLeave,BufEnter * match Error /\v\s+$/
    autocmd InsertEnter,BufLeave * match
    autocmd BufWritePre * :call <SID>StripTrailingWhitespace()
augroup END

function! s:StripTrailingWhitespace()
    %s/\v\s+$//e
endfunction " }}}

" spellcheck {{{
function! s:SpellCheckToggle(...)
    set spell!
    echomsg a:1
    let &spelllang = a:1
endfunction

nnoremap <F5> :call <SID>SpellCheckToggle("en")<CR>
" }}}  }}}

" pathogen {{{

execute pathogen#infect()

colorscheme jellybeans

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = '✗'                  "Also applies to YCM
let g:syntastic_warning_symbol = '⚠'                "Also applies to YCM

" YCM
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = ['~/Projects/*']
"whitelist only given languages
let g:ycm_filetype_whitelist = {
            \ 'python'  : 1,
            \ 'cpp'     : 1,
            \ 'hpp'     : 1,
            \ 'c'       : 1,
            \ 'h'       : 1,
            \ 'java'    : 1
            \}

let g:EclimCompletionMethod = 'omnifunc'
let g:ycm_python_binary_path = '/usr/bin/python3'
"jump to definition
nnoremap <leader>d :YcmCompleter GoTo<CR>

" delimitMate
"correct expansion
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 0
let g:delimitMate_smart_matchpairs = 1
let g:delimitMate_balance_matchpairs = 1
let g:delimitMate_expand_inside_quotes = 1

" SimpylFold
let g:SimpylFold_docstring_preview = 1
let g:SimpylFold_fold_docstring = 0
" }}}

" filetype settings {{{
augroup filetype_vim " {{{
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim nnoremap <buffer> <localleader>c I"<esc>
augroup END " }}}

augroup filetype_html " {{{
    autocmd!
    autocmd BufNewFile,BufRead *.html setlocal nowrap
    autocmd FileType html setlocal shiftwidth=2 tabstop=2
augroup END " }}}

augroup filetype_javascript " {{{
    autocmd!
    autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
    autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
augroup END " }}}

augroup filetype_python " {{{
    autocmd!
    autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>

    " SimpylFold
    autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
    autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<
augroup END " }}}

augroup filetype_markdown " {{{
    autocmd!
    onoremap ih :<c-u>execute "normal! ?^\\(==\\+\\\\|--\\+\\)$\r:nohlsearch\rkvg_"<cr>
    onoremap ah :<c-u>execute "normal! ?^\\(==\\+\\\\|--\\+\\)$\r:nohlsearch\rg_vk0"<cr>
    autocmd Filetype markdown let b:delimitMate_nesting_quotes = ['`']
augroup END " }}}

augroup filetype_c_langs " {{{
    autocmd!
    set smartindent
augroup END " }}}
" }}}
