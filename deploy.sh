#!/bin/bash

DIR=`git rev-parse --show-toplevel`

#mkdir -p ~/.vim ~/.vim/autoload ~/.vim/bundle 
#if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
#	echo "Downloading pathogen for vim"
#	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
#fi
#
#echo "Fectching new vim plugins.."
#cd ~/.vim/bundle
#while IFS='' read -r line || [[ -n "$line" ]]; do
#	dir_name=`perl -e '$_=shift; chomp; s/.*\/(.*)\.git$/\1/; print;' $line`
#	if [ ! -d $dir_name ]; then
#		echo -n "Cloning plugin $dir_name."
#		git clone $line
#	fi
#done < $DIR/other/vim-plugin.list
#cd - > /dev/null

if [ `uname -o` == 'Cygwin' ]; then
	CYGWIN=true
fi

if [ ! -f ~/.env ]; then
	echo "export CFG_SCRIPT_DIR=$DIR" > ~/.env
fi

echo -n "Adding simlinks for dotFiles... "
ln -f -s $DIR/runcon/vimrc ~/.vimrc
ln -f -s $DIR/runcon/bashrc ~/.bashrc
ln -f -s $DIR/runcon/screenrc ~/.screenrc
ln -f -s $DIR/runcon/Xresources ~/.Xresources
ln -f -s $DIR/runcon/Xinitrc ~/.Xinitrc
ln -f -s $DIR/runcon/Xmodmap ~/.Xmodmap
ln -f -s $DIR/runcon/minttyrc ~/.minttyrc
ln -f -s $DIR/runcon/tmux.conf ~/.tmux.conf
echo "Done."

echo -n "Adding custom scripts... "
mkdir -p ~/bin
cp -f -r scripts/* ~/bin/
echo "Done."

echo -n "Resourcing bashrc... "
source ~/.bashrc
echo "Done."

echo -e "\nFollowing are your favorite tools make sure you install them!"
cat $DIR/other/software.list

