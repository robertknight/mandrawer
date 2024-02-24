# Get path to this script, assuming it loaded via a symlink.
set SCRIPT_DIR (dirname (readlink (status --current-filename)))

# Helpers
function add_dir_to_path
  set dir $argv[1]
  if test -d $dir
    set -x PATH $dir $PATH
  end
end

function eval_if_exists
  set path $argv[1]
  if test -f $path
    source $path
  end
end

# Basic fish setup
fish_vi_key_bindings

# Language-specific binary dirs
add_dir_to_path $HOME/projects/go/bin
add_dir_to_path $HOME/other/go/bin
add_dir_to_path $HOME/.cargo/bin

# Setup pyenv
status --is-interactive; and pyenv init --path | source

# Setup autoenv
# (https://github.com/idan/autoenvfish)
set AUTOENV_SRC $SCRIPT_DIR/../vendor/fish/autoenv.fish
source $AUTOENV_SRC

eval_if_exists /usr/local/share/autojump/autojump.fish

# Setup FZF (https://github.com/junegunn/fzf)
# Use fd to respect .gitignore. See https://github.com/junegunn/fzf#respecting-gitignore
set -x FZF_DEFAULT_COMMAND 'fd --type f'

# Aliases
alias pr "poetry run"
alias nv nvim

# Run Python 3 in a way that is compatible with matplotlib.
# See https://matplotlib.org/faq/osx_framework.html#pythonhome-function
alias frameworkpython 'env PYTHONHOME=$VIRTUAL_ENV /usr/local/bin/python3'

# Disable fish shell greeting.
# See https://stackoverflow.com/questions/13995857
set fish_greeting

# Created by `pipx` on 2021-05-27 15:20:43
set PATH $PATH /Users/robert/.local/bin

# pnpm
set -gx PNPM_HOME "/Users/robert/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
set -gx WASMTIME_HOME "$HOME/.wasmtime"

string match -r ".wasmtime" "$PATH" > /dev/null; or set -gx PATH "$WASMTIME_HOME/bin" $PATH
