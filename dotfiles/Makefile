install: install_fish_prompt install_dotfiles

FISH_FUNC_DIR=$(HOME)/.config/fish/functions

install_fish_prompt:
	mkdir -p $(FISH_FUNC_DIR)
	ln -s $(abspath fish_prompt.fish) $(FISH_FUNC_DIR)

install_dotfiles:
	ln -s $(abspath .ackrc) $(HOME)
	ln -s $(abspath .gitconfig) $(HOME)
	ln -s $(abspath .vimrc) $(HOME)
