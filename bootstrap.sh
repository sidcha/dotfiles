#!/bin/bash

if [ ! -d ~/.files ]; then
	if [ ! command -v git &>/dev/null ]; then
		echo "Downloading github.com/sidcha/dotfiles master"
		wget -O /tmp/master.zip https://github.com/sidcha/dotfiles/archive/refs/heads/master.zip
		unzip -q /tmp/master.zip && rm /tmp/master.zip
		mv dotfiles-master ~/.files
	else
		echo "Cloning github.com/sidcha/dotfiles"
		git clone https://github.com/sidcha/dotfiles.git ~/.files
	fi
fi

if [ -d ~/.files/.git ]; then
	echo "Updating ~/.files"
	git -C ~/.files pull origin master
fi

~/.files/deploy.sh && echo -e "\n\nInstalled successfully."
