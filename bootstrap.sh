#!/bin/bash

die {
	echo $1
	exit 1
}

git clone https://github.com/cbsiddharth/dotfiles.git $HOME/.files \
		|| die "Could not clone the repository"

cd $HOME/.file && ./deploy.sh

echo "Installed successfully."
