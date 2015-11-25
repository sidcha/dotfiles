#!/bin/bash

#mkdir -p ~/.vim/autoload ~/.vim/bundle 
#curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle
while IFS='' read -r line || [[ -n "$line" ]]; do
	git clone $line
done < ~/customizer/scripts/vim-setup/plugin.list
cd -
