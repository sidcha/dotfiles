#!/bin/bash
DIR=$PWD
echo "Seting up siddhart's customizations"

echo "Asking vimrc to source external customization file.."
echo ":source $DIR/runcon/vimrc" > ~/.vimrc

echo "Asking bashrc to source external customization file.."
echo "source $DIR/runcon/bashrc" > ~/.bashrc

mkdir -p ~/bin
echo "Adding vcprompt executable to local bin"
#cp scripts/vcprompt ~/bin/vcprompt

echo "Resourcing bashrc"
. ~/.bashrc

echo "All Done"
