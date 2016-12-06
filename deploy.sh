#!/bin/bash

DIR=`git rev-parse --show-toplevel`

if [ ! -d ~/.vim ]; then
	echo "Unable to find a .vim directory. Perhaps you haven't installed?"
else
	if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
		echo "Downloading pathogen for vim"
		mkdir -p ~/.vim/autoload ~/.vim/bundle 
		curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	fi

	if [ ! -d ~/.vim/bundle ]; then
		echo "Fectching vim plugins.."
		mkdir -p ~/.vim/bundle
		cd ~/.vim/bundle
		while IFS='' read -r line || [[ -n "$line" ]]; do
			echo -n "Cloning from $line... "
			git clone $line > /dev/null
			echo "Done."
		done < $DIR/other/vim-plugin-git-url.list
		cd - > /dev/null
	fi
fi

if [ ! -f ~/.env ]; then
	echo "export CFG_SCRIPT_DIR=$DIR" > ~/.env
fi

echo -n "Adding simlinks for dotFiles... "
ln -f -s $DIR/runcon/vimrc ~/.vimrc
ln -f -s $DIR/runcon/bashrc ~/.bashrc
ln -f -s $DIR/runcon/screenrc ~/.screenrc
ln -f -s $DIR/runcon/Xresources ~/.Xresources
echo "Done."

echo -n "Adding custom scripts... "
mkdir -p ~/bin
cp -f -r scripts/* ~/bin/
echo "Done."

echo -n "Resourcing bashrc... "
. ~/.bashrc > /dev/null
echo "Done."

echo "All Done"

