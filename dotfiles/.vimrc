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

" Find a character across multiple lines.
" These alter the behavior of the built-in "f" and "t" motions.
Plug 'tpope/vim-repeat'
Plug 'dahu/vim-fanfingtastic'

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

" ale config
let g:ale_completion_enabled = 1
let g:ale_linters = {
\  'javascript': ['eslint', 'tsserver'],
\  'python': ['flake8', 'mypy', 'pyls'],
\  'html': [],
\}
let g:ale_fixers = {
\  'javascript': ['prettier'],
\  'typescript': ['prettier'],
\  'python': ['black'],
\  '*': ['remove_trailing_lines', 'trim_whitespace'],
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

" --------------------
" Key bindings
" --------------------

:map <Leader>c :close<CR>

" Find files in project
:map <Leader>f :FZF<CR>

" Find tags in project. Relies on vim-gutentags to build the tags file automatically.
:map <Leader>t :Tags<CR>

" Auto-format code
:map <Leader>F :ALEFix<CR>

" Go to definition, references etc. Requires LSP to be active for current file
" and configured in ALE.
:map <Leader>h :ALEHover<CR>
:map <Leader>r :ALEFindReferences<CR>
:map <Leader>d :ALEGoToDefinition<CR>
:map <Leader>D :ALEGoToDefinitionInSplit<CR>
