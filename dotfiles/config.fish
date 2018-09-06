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

# Setup virtualfish for Python
eval (/usr/bin/python -m virtualfish auto_activation)

# Setup autoenv
# (https://github.com/idan/autoenvfish)
set AUTOENV_SRC $SCRIPT_DIR/../vendor/fish/autoenv.fish
source $AUTOENV_SRC

eval_if_exists /usr/local/share/autojump/autojump.fish

# Setup GPG agent
setup_gpg_agent

# Aliases
alias nv nvim

# Run Python 3 in a way that is compatible with matplotlib.
# See https://matplotlib.org/faq/osx_framework.html#pythonhome-function
alias frameworkpython 'env PYTHONHOME=$VIRTUAL_ENV /usr/local/bin/python3'
