#!/bin/bash

DIR=`git rev-parse --show-toplevel`

if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
	mkdir -p ~/.vim/autoload ~/.vim/bundle 
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

if [ ! -d ~/.vim/bundle ]; then
	mkdir -p ~/.vim/bundle
	cd ~/.vim/bundle
	while IFS='' read -r line || [[ -n "$line" ]]; do
		echo -n "Cloning from $line... "
		git clone $line > /dev/null
		echo "Done."
	done < $DIR/other/vim-plugin-git-url.list
	cd - > /dev/null
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

