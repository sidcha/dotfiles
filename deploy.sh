#!/bin/bash
DIR=$PWD

echo "Adding simlinks for dotFiles.."
ln -f -s customizer/runcon/vimrc ~/.vimrc
ln -f -s customizer/runcon/bashrc ~/.bashrc
ln -f -s customizer/runcon/screenrc ~/.screenrc

mkdir -p ~/bin
echo "Adding vcprompt executable to local bin"
cd $DIR/scripts/vcprompt/vcprompt-1.2.1
make
cp vcprompt* ~/bin/
cd -

echo "Resourcing bashrc"
. ~/.bashrc

echo "All Done"
