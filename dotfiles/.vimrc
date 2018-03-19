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

" (F)ind (A)nd (R)eplace
Plug 'brooth/far.vim'

" TypeScript language server integration
Plug 'Quramy/tsuquyomi'
Plug 'leafgarland/typescript-vim'

Plug 'editorconfig/editorconfig-vim'
Plug 'elmcast/elm-vim'

" Linter integration
Plug 'w0rp/ale'  " nb. Requires Vim 8
" Plug 'flowtype/vim-flow'

" Automated source formatting
Plug 'sbdchd/neoformat'

" CoffeeScript
Plug 'kchmck/vim-coffee-script'

" Jump-to-line in GitHub
Plug 'ruanyl/vim-gh-line'

" Vue single-file (.vue) components
Plug 'posva/vim-vue'

call plug#end()

" Basic editor settings
" ---------------------
set backspace=indent,eol,start
set sw=4
set ts=4
set tw=80
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

" Show trailing whitespace, except when typing at the end of a line.
" See http://vim.wikia.com/wiki/Highlight_unwanted_spaces
:highlight TrailingSpace ctermbg=red guibg=red
:match TrailingSpace /\s\+\%#\@<!$/

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

" ale config
let g:ale_linters = {
\  'javascript': ['eslint'],
\  'python': ['flake8', 'mypy'],
\  'html': [],
\}

" Display lint errors in status line
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
set statusline+=%{ALEGetStatusLine()}

" `ag` integration
" See https://github.com/mileszs/ack.vim#can-i-use-ag-the-silver-searcher-with-this
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
