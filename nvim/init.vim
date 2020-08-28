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

" Ale
Plug 'w0rp/ale'

" coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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
call coc#add_extension('coc-json', 'coc-python')

" Use <c-n> and <c-p> to trigger completion.
inoremap <silent><expr> <c-n>
  \ pumvisible() ? "\<C-n>" :
  \ coc#refresh()
inoremap <silent><expr> <c-p>
  \ pumvisible() ? "\<C-p>" :
  \ coc#refresh()

" All of the diagnostics are put in the location list (:lopen),
" with unimpaired.vim use ]l and [l to navigate
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <leader>e  :<C-u>CocList diagnostics<cr>
" Manage extensions.
"nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <leader>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <leader>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <leader>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
"nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
"nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <leader>p  :<C-u>CocListResume<CR>
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
