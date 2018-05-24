#!/usr/bin/env python

from __future__ import print_function

import distutils.dir_util
import glob
import os.path


DOTFILE_DIR = os.path.dirname(os.path.realpath(__file__))
HOME_DIR = os.environ['HOME']
FISH_CONFIG_DIR = os.path.join(HOME_DIR, '.config/fish')
FISH_FUNC_DIR = os.path.join(FISH_CONFIG_DIR, 'functions')


def yes_no_prompt(prompt):
    result = raw_input('%s [Y/N]\n' % prompt)
    return result.lower() in ['y', 'yes']


def install_symlink(src, dest_dir):
    distutils.dir_util.mkpath(dest_dir)
    dest_path = os.path.join(dest_dir, os.path.basename(src))
    abs_src_path = os.path.join(DOTFILE_DIR, src)
    if os.path.lexists(dest_path):
        if os.readlink(dest_path) == abs_src_path:
            # Symlink already exists and points to target file.
            return
        if not yes_no_prompt('Replace existing file \'%s\'?' % dest_path):
            return
        os.unlink(dest_path)
    os.symlink(abs_src_path, dest_path)
    print('Created symlink %s -> %s' % (abs_src_path, dest_path))


def setup_fish():
    install_symlink('config.fish', FISH_CONFIG_DIR)
    install_symlink('fish_prompt.fish', FISH_FUNC_DIR)
    install_symlink('setup_gpg_agent.fish', FISH_FUNC_DIR)


def symlink_dotfiles():
    dotfiles = glob.glob('.*')
    for dotfile in dotfiles:
        install_symlink(dotfile, HOME_DIR)


def main():
    symlink_dotfiles()
    setup_fish()


if __name__ == '__main__':
    main()
