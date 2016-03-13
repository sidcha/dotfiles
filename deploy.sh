#!/bin/bash
DIR=$PWD

mkdir -p ~/.vim/autoload ~/.vim/bundle 
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle
while IFS='' read -r line || [[ -n "$line" ]]; do
	git clone $line
done < ~/customizer/other/vim-plugin-git-url.list
cd $DIR

echo "Adding simlinks for dotFiles.."
ln -f -s customizer/runcon/vimrc ~/.vimrc
ln -f -s customizer/runcon/bashrc ~/.bashrc
ln -f -s customizer/runcon/screenrc ~/.screenrc

cp scripts/create.pl ~/bin/

mkdir -p ~/bin
echo "Adding vcprompt executable to local bin"
cd scripts/vcprompt/vcprompt-1.2.1
make -f Makefile.in
make
cp vcprompt* ~/bin/
cd $DIR

echo "Resourcing bashrc"
. ~/.bashrc

echo "All Done"
