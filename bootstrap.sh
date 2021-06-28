#!/bin/bash

if [ ! -d ~/.files ]; then
	echo "Cloning https://github.com/sidcha/dotfiles.git"
	git clone https://github.com/sidcha/dotfiles.git $HOME/.files
else
	echo "Updating ~/.files"
	git -C ~/.files pull origin master
fi

~/.files/deploy.sh && echo -e "\n\nInstalled successfully."
