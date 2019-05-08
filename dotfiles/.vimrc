set nocompatible

" ---------------------------
" Plugin setup (via vim-plug)
" ---------------------------

call plug#begin('~/.vim/plugged')

" General purpose
" ~~~~~~~~~~~~~~~

" Async exec library
Plug 'Shougo/vimproc.vim', {'do': 'make'}

" Fuzzy file finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Improved directory navigation with netrw
Plug 'tpope/vim-vinegar'

" 'ag' (Silver Surfer) integration
Plug 'mileszs/ack.vim'

" (F)ind (A)nd (R)eplace
Plug 'brooth/far.vim'

" Git wrapper
Plug 'tpope/vim-fugitive'

" Git status info in gutter
Plug 'airblade/vim-gitgutter'

" Dir tree explorer
Plug 'scrooloose/nerdtree'

" Open URL in browser
Plug 'dhruvasagar/vim-open-url'

" Rename/delete buffers and associated files
Plug 'tpope/vim-eunuch'

" Multi-language
" ~~~~~~~~~~~~~~

" Comment out code easily
Plug 'tpope/vim-commentary'

" editorconfig support
Plug 'editorconfig/editorconfig-vim'

" Linter integration
Plug 'w0rp/ale'

" Automated source formatting
Plug 'sbdchd/neoformat'

" Jump-to-line in GitHub
Plug 'ruanyl/vim-gh-line'

" Code completion
Plug 'maralla/completor.vim'

" Automatic ctags builder
Plug 'ludovicchabant/vim-gutentags'

" Language-specific
" ~~~~~~~~~~~~~~~~~

" CoffeeScript
Plug 'kchmck/vim-coffee-script'

" Elm
Plug 'elmcast/elm-vim'

" JavaScript
Plug 'Galooshi/vim-import-js'  " Auto-insert ES6/CJS imports
Plug 'prettier/vim-prettier'  " Auto-format code

" Markdown
Plug 'gabrielelana/vim-markdown'

" NGINX
Plug 'chr4/nginx.vim'

" Python
Plug 'ambv/black'

" TypeScript
Plug 'Quramy/tsuquyomi'
Plug 'leafgarland/typescript-vim'

" Vue
Plug 'posva/vim-vue'

call plug#end()

" ---------------------
" Basic editor settings
" ---------------------

set backspace=indent,eol,start
set sw=4
set ts=4
set tw=100
set colorcolumn=81,101
hi ColorColumn ctermbg=lightgrey guibg=lightgrey
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

" --------------------
" Plugin configuration
" --------------------

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

" vim-fzf
:map <Leader>f :FZF<CR>
:map <Leader>t :Tags<CR>

" Language Server Protocol-based code navigation and completion.
" See https://github.com/w0rp/ale#2iv-go-to-definition
:map <F6> :ALEHover<CR>
:map <F7> :ALEFindReferences<CR>
:map <F8> :ALEGoToDefinition<CR>

" ale config
let g:ale_completion_enabled = 1
let g:ale_linters = {
\  'javascript': ['eslint', 'tsserver'],
\  'python': ['flake8', 'mypy', 'pyls'],
\  'html': [],
\}

" Disable highlights, as these can make it hard to read text depending on the
" color scheme. Lint failures are highlighted via markers in the gutter
" instead.
let g:ale_set_highlights = 0

" `ag` integration
" See https://github.com/mileszs/ack.vim#can-i-use-ag-the-silver-searcher-with-this
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Use silver searcher to find candidates in far.vim.
" Useful because it respects .gitignore
"
" Important Note: This makes "Far" operations use a regexp rather than a
" vimgrep-style pattern as the file mask.
let g:far#source = 'ag'
