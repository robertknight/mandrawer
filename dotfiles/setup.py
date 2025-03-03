#!/usr/bin/env python3

import glob
from pathlib import Path
import os.path


DOTFILE_DIR = os.path.dirname(os.path.realpath(__file__))
HOME_DIR = os.environ['HOME']
UNIVERSAL_CTAGS_CONFIG_DIR = os.path.join(HOME_DIR, '.ctags.d')
FISH_CONFIG_DIR = os.path.join(HOME_DIR, '.config/fish')
FISH_FUNC_DIR = os.path.join(FISH_CONFIG_DIR, 'functions')
NVIM_CONFIG_DIR = os.path.join(HOME_DIR, '.config/nvim')


def yes_no_prompt(prompt):
    result = input('%s [Y/N]\n' % prompt)
    return result.lower() in ['y', 'yes']


def install_symlink(src, dest_dir):
    Path(dest_dir).mkdir(parents=True, exist_ok=True)
    dest_path = os.path.join(dest_dir, os.path.basename(src))
    abs_src_path = os.path.join(DOTFILE_DIR, src)
    if os.path.lexists(dest_path):
        if os.path.islink(dest_path) and os.readlink(dest_path) == abs_src_path:
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


def setup_ctags():
    install_symlink('config.ctags', UNIVERSAL_CTAGS_CONFIG_DIR)


def setup_neovim():
    install_symlink('init.vim', NVIM_CONFIG_DIR)


def symlink_dotfiles():
    dotfiles = glob.glob('.*')
    for dotfile in dotfiles:
        install_symlink(dotfile, HOME_DIR)


def main():
    symlink_dotfiles()
    setup_ctags()
    setup_fish()
    setup_neovim()


if __name__ == '__main__':
    main()
