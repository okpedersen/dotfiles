" General configuration {{{

" basic settings
filetype plugin indent on       "load plugins and indent files
syntax on                       "enable syntax highlightning
if !has('nvim')
    set encoding=utf8
endif
set fileformat=unix
set hidden                      "hide buffers when not displayed

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
set expandtab       " tabs to spaces
set smarttab
set shiftwidth=2    " four spaces as default
set tabstop=2
set autoindent

" natural splits
set splitright
set splitbelow

set completeopt=longest,menuone,preview

" allow project-specific .vimrc
set exrc
set secure
" }}}

" Custom keyboard remaps {{{

" change leaders
let mapleader=" "
let maplocalleader="\\"

" set jk as escape button in insert mode
inoremap jj <ESC>
tnoremap <ESC> <C-\><C-n>

"enable fast .vimrc editing
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" reselect visualblock after indent/outdent
vnoremap > >gv
vnoremap < <gv

" easy split navigation
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l

" fast save
nnoremap <leader>w :w<CR>

" use very magic as default when searching
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
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }}}

" enable cursorline {{{
augroup enable_cursorline
    autocmd!
    autocmd BufEnter * set cursorline
    autocmd BufLeave * set nocursorline
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
" }}}

" teminal settings {{{
if has('nvim')
    augroup terminal_autocommands
        autocmd!
        autocmd WinEnter,BufEnter term://* startinsert
        autocmd BufLeave term://* stopinsert
    augroup END
endif
" }}}
" }}}

" pathogen {{{

"execute pathogen#infect()


" syntastic
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 2                   "Automatically close, but not open
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_loc_list_height=5
"let g:syntastic_error_symbol = '✗'                  "Also applies to YCM
"let g:syntastic_warning_symbol = '⚠'                "Also applies to YCM
"
""
""
""
" YCM
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = ['~/Projects/*', '~/Dropbox/*']
"
" delimitMate
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 0
let g:delimitMate_smart_matchpairs = 1
let g:delimitMate_balance_matchpairs = 1

" SimpylFold
let g:SimpylFold_docstring_preview = 1
let g:SimpylFold_fold_docstring = 0
"" }}}

let g:python3_host_prog = '/home/okpedersen/.virtualenvs/nvimpy3/bin/python'
let g:python_host_prog = '/home/okpedersen/.virtualenvs/nvimpy2/bin/python'

call plug#begin('~/.config/nvim/plugged')
" UI/colorscheme
Plug 'nanotech/jellybeans.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" git
Plug 'tpope/vim-fugitive'

" misc
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdcommenter'
"Plug 'ervandew/supertab'

"Plug 'ledger/vim-ledger'
"
Plug 'artur-shaik/vim-javacomplete2'
Plug 'derekwyatt/vim-scala'

" C++
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --tern-completer', 'for' : ['c', 'cpp', 'python']}
"Plug
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-clang'
Plug 'Shougo/neoinclude.vim'
Plug 'neomake/neomake'

"latex
Plug 'lervag/vimtex', {'for' : 'tex'}

"python
Plug 'nvie/vim-flake8', {'for' : 'python'}
Plug 'zchee/deoplete-jedi', {'for' : 'python'}
Plug 'tmhedberg/SimpylFold', {'for' : 'python'}

let g:python_host_prog = '/home/okpedersen/.virtualenvs/nvimpy2/bin/python'
let g:python3_host_prog = '/home/okpedersen/.virtualenvs/nvimpy3/bin/python'



"elm
Plug 'elmcast/elm-vim'

" Polyglot
Plug 'sheerun/vim-polyglot'

call plug#end()

let g:deoplete#enable_at_startup = 1
"let g:deoplete#sources = {}
"let g:deoplete#sources._ = ['file', 'neosnippet']
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
let g:neomake_cpp_enabled_makers=['clangtidy', 'clangcheck', 'clang']
let g:neomake_cpp_clangtidy_args=['-checks=*,-llvm-header-guard,-clang-diagnostic-pragma-once-outside-header,-cppcoreguidelines-pro-bounds-pointer-arithmetic', '-extra-arg=-std=c++14', '-extra-arg-before=-xc++']
let g:neomake_cpp_clangcheck_args=["-analyze", "-extra-arg=-std=c++17", "-extra-arg-before=-xc++"]
let g:neomake_cpp_clang_maker = {
            \ 'exe' : 'clang++',
            \ 'args' : ["-fsyntax-only", "-Wall", "-Wextra", "-std=c++17", "-xc++", "-Wno-pragma-once-outside-header"],
            \}
"let g:deoplete#omni_patterns = {}
"let g:deoplete#omni_patterns.java = '[^. *\t]\.\w*'
let g:deoplete#auto_completion_start_length = 0
"let g:deoplete#file#enable_buffer_path = 1
"autocmd FileType java setlocal omnifunc=javacomplete#Complete
"let g:deoplete#omni#functions = {}
"let g:deoplete#omni#input_patterns = {}
"let g:deoplete#omni#functions.elm = ['elm#Complete']
"let g:deoplete#omni#input_patterns.elm = '[^ \t]+'
"let g:deoplete#sources.elm = ['omni'] + g:deoplete#sources._

" jellybeans
colorscheme jellybeans

"syntastic
let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 2                   "Automatically close, but not open
let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"let g:syntastic_loc_list_height=5
"let g:syntastic_error_symbol = '✗'                  "Also applies to YCM
"let g:syntastic_warning_symbol = '⚠'                "Also applies to YCM
let g:airline#extensions#syntastic#enabled = 0

" NERDTree
" TODO: vinegar?
map <leader>f :NERDTreeToggle<CR>
let g:NERDTreeWinSize = 24
"let g:NERDTreeMinimalUI = 1
augroup NERDTree
  autocmd!
  autocmd VimEnter * if (0 == argc()) | NERDTree | endif
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" elm
let g:polyglot_disabled = ['elm', 'python']
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 1
let g:elm_syntastic_show_warnings = 1
let g:elm_setup_keybindings = 1
"let g:elm_make_show_warnings = 1

noremap <leader>m :ElmMake<CR>
noremap <leader>b :ElmMakeMain<CR>
noremap <leader>t :ElmTest<CR>
noremap <leader>r :ElmRepl<CR>
noremap <leader>ed :ElmErrorDetail<CR>
noremap <leader>d :ElmShowDocs<CR>


" Superttab
"let g:SuperTabDefaultCompletionType = '<c-n>'
"inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : deoplete#mappings#manual_complete()


" filetype settings {{{
augroup filetype_settings_vimrc
    autocmd!
    " VimScript
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim nnoremap <buffer> <localleader>c I"<esc>

    "elm
    autocmd FileType elm setlocal shiftwidth=4 tabstop=4

    " HTML
    autocmd BufNewFile,BufRead *.html setlocal nowrap

    " JS
    autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>


    let g:syntastic_python_checkers=['flake8']
    let g:syntastic_python_flake8_args='--ignore=E501'
    autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
    autocmd FileType python setlocal shiftwidth=4 | setlocal tabstop=4

    " Python
    " - delimitMate
    autocmd FileType python let b:delimitMate_quotes = "\""
    " - SimpylFold
    "autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
    "autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<
    autocmd FileType python setlocal sw=4 ts=4

    " TODO fix triple quotes for markdown
    autocmd Filetype markdown let b:delimitMate_nesting_quotes = ['`']
augroup END
" }}}

