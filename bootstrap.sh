#!/usr/bin/env bash
set -euo pipefail

if [ ! -d ~/.files ]; then
	if ! command -v git >/dev/null 2>&1; then
		echo "Downloading github.com/sidcha/dotfiles master"
		curl -fsSL -o /tmp/master.zip https://github.com/sidcha/dotfiles/archive/refs/heads/master.zip
		unzip -q /tmp/master.zip -d /tmp && rm /tmp/master.zip
		mv /tmp/dotfiles-master ~/.files
	else
		echo "Cloning github.com/sidcha/dotfiles"
		git clone https://github.com/sidcha/dotfiles.git ~/.files
	fi
fi

if [ -d ~/.files/.git ]; then
	echo "Updating ~/.files"
	git -C ~/.files pull origin master
fi

~/.files/deploy.sh
echo -e "\n\nInstalled successfully."
