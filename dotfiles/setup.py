#!/usr/bin/env python

from __future__ import print_function

import distutils.dir_util
import glob
import os.path

HOME_DIR = os.environ['HOME']
FISH_FUNC_DIR = os.path.join(HOME_DIR, '.config/fish/functions')

def yes_no_prompt(prompt):
    result = raw_input('%s [Y/N]\n' % prompt)
    return result.lower() in ['y', 'yes']

def install_symlink(src, dest_dir):
    distutils.dir_util.mkpath(dest_dir)
    dest_path = os.path.join(dest_dir, os.path.basename(src))
    if os.path.exists(dest_path):
        if not yes_no_prompt('Replace existing file \'%s\'?' % dest_path):
            sys.exit(1)
        os.unlink(dest_path)
    os.symlink(os.path.abspath(src), dest_path)
    print('Created symlink %s -> %s' % (src, dest_path))

def setup_prompt():
    install_symlink('fish_prompt.fish', FISH_FUNC_DIR)

def symlink_dotfiles():
    dotfiles = glob.glob('.*')
    for dotfile in dotfiles:
        install_symlink(dotfile, HOME_DIR)

def main():
    symlink_dotfiles()
    setup_prompt()
    
if __name__ == '__main__':
    main()    
