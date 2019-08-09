set nocompatible

" ---------------------------
" Plugin setup (via vim-plug)
" ---------------------------

call plug#begin('~/.vim/plugged')

" General purpose
" ~~~~~~~~~~~~~~~

" Async exec library
Plug 'Shougo/vimproc.vim', {'do': 'make'}

" Find files, tags, lines and more with fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
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

" Surround selection with braces, quotes, XML-style tags etc.
Plug 'tpope/vim-surround'

" Indentation-based text objects
Plug 'michaeljsmith/vim-indent-object'

" Atom-inspired color scheme (24-bit)
Plug 'joshdick/onedark.vim'

" Multi-language
" ~~~~~~~~~~~~~~

" Comment out code easily
Plug 'tpope/vim-commentary'

" editorconfig support
Plug 'editorconfig/editorconfig-vim'

" Lint, format and navigate around code
Plug 'w0rp/ale'

" Jump-to-line in GitHub
Plug 'ruanyl/vim-gh-line'

" Code completion
" Plug 'maralla/completor.vim'

" Build ctags files automatically
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
" Improved syntax highlighting.
" nb. Was disabled at one point in the past due to impact on startup time.
Plug 'pangloss/vim-javascript'

" Jinja2
Plug 'Glench/Vim-Jinja2-Syntax'

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

" Enable 24-bit color.
set termguicolors
" Make `termguicolors` work even if `$TERM` is not `xterm`.
" See `xterm-true-color`
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"

set backspace=indent,eol,start
set sw=4
set ts=4
set tw=100
set autoindent
set linebreak
set mouse=a
set ignorecase
set smartcase

set colorcolumn=81,101
highlight ColorColumn ctermbg=darkgrey guibg=lightgrey

" Use bash for running external commands since
" fish is not POSIX compatible
set shell=/bin/bash

filetype plugin on
filetype indent on
syntax on
colorscheme onedark

" Syntax highlighting tweaks
" These must be applied after `syntax on`
"
" Run `:so $VIMRUNTIME/syntax/hitest.vim` to preview.
highlight Statement ctermfg=yellow

" Show trailing whitespace, except when typing at the end of a line.
" See http://vim.wikia.com/wiki/Highlight_unwanted_spaces
:highlight TrailingSpace ctermbg=red guibg=red
:match TrailingSpace /\s\+\%#\@<!$/

" Add suffixes to try when using `gf` command.
:set suffixesadd+=.js
:set suffixesadd+=.ts

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

" Replace the not-very-useful built-in omni-completions with LSP-provided
" completions from ALE.
:autocmd FileType * :setlocal omnifunc=ale#completion#OmniFunc

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
:map <Leader>ff :FZF<CR>

" Find tags in project. Relies on vim-gutentags to build the tags file automatically.
:map <Leader>ft :Tags<CR>

" Find tags in current buffer
:map <Leader>bt :BTags<CR>

" Find lines in current buffer
:map <Leader>bl :BLines<CR>

" Find lines in active/all buffers
:map <Leader>Bl :Lines<CR>

" Auto-format code
:map <Leader>F :ALEFix<CR>

" Go to next lint error in buffer
:map <Leader>be :ALENext -wrap<CR>

" Go to definition, references etc. Requires LSP to be active for current file
" and configured in ALE.
:map <Leader>d :ALEGoToDefinition<CR>
:map <Leader>D :ALEGoToDefinitionInSplit<CR>
:map <Leader>h :ALEHover<CR>
:map <Leader>i :ALEDocumentation<CR>
:map <Leader>r :ALEFindReferences<CR>
