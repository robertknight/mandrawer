# Get path to this script, assuming it loaded via a symlink.
set SCRIPT_DIR (dirname (readlink (status --current-filename)))

set -x PATH $HOME/projects/go/bin $HOME/other/go/bin $PATH

# Setup virtualfish for Python
eval (python -m virtualfish)

# Setup autoenv
# (https://github.com/idan/autoenvfish)
set AUTOENV_SRC $SCRIPT_DIR/../vendor/fish/autoenv.fish
source $AUTOENV_SRC
