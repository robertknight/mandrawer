set nocompatible

" Plugin setup (via vim-plug)
" ---------------------------

call plug#begin('~/.vim/plugged')

" Async exec library
Plug 'Shougo/vimproc.vim', {'do': 'make'}

" Fuzzy file finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" 'ag' (Silver Surfer) integration
Plug 'mileszs/ack.vim'

" TypeScript language server integration
Plug 'Quramy/tsuquyomi'

Plug 'editorconfig/editorconfig-vim'

" Linter integration
Plug 'vim-syntastic/syntastic'

call plug#end()

" Basic editor settings
" ---------------------
set sw=4
set ts=4
set autoindent
set linebreak
set mouse=a
set ignorecase
set smartcase

" Use bash for running external commands since
" fish is not POSIX compatible
set shell=/bin/bash

filetype plugin on
filetype indent on
syntax on

" Language and tool integrations
" ------------------------------

" Load Go support
set runtimepath+=$HOME/other/go/misc/vim
au BufNewFile,BufRead *.go set ft=go
let g:gofmt_command="goimports"

" Load typescript support
function InitTypeScript()
	set ft=typescript
	set makeprg=make
endfunction
set runtimepath+=$HOME/other/typescript-vim/
au BufNewFile,BufRead *.ts call InitTypeScript()

" elm-vim config
" https://github.com/ElmCast/elm-vim
let g:elm_format_autosave = 1

let mandrawer_dir=expand("$HOME/projects/mandrawer")
:map <F2> :exec("!" . mandrawer_dir . "/ctags.sh")<CR>
:map <F5> :make<CR>

" Syntastic config.
" Adapted from the recommendations in
" https://github.com/vim-syntastic/syntastic#3-recommended-settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers = ['flake8']
let g:syntastic_javascript_checkers = ['eslint']

" `ag` integration
" See https://github.com/mileszs/ack.vim#can-i-use-ag-the-silver-searcher-with-this
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

