#!/bin/bash

DIR=$(realpath "$(dirname "$(readlink -f "$0")")")
pushd ${DIR} 2>&1 > /dev/null

mkdir -p ~/.vim ~/.vim/autoload ~/.vim/bundle ~/.vim/spell ~/.vim/syntax
if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
	echo "Downloading pathogen for vim"
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

touch ~/.vim/spell/en.utf-8.add
echo "Fectching new vim plugins.."
cd ~/.vim/bundle
while IFS='' read -r line || [[ -n "$line" ]]; do
	dir_name=`perl -e '$_=shift; chomp; s/.*\/(.*)\.git$/\1/; print;' $line`
	if [ ! -d $dir_name ]; then
		echo -n "Cloning plugin $dir_name."
		git clone $line
	fi
done < $DIR/other/vim-plugin.list
cd - > /dev/null

cat > ~/.vim/syntax/c.vim < ---
syn match       cType "\<[a-zA-Z_][a-zA-Z0-9_]*_[t]\>"
syn keyword     cType i8 u8 i16 u16 i32 u32 i64 u64
syn keyword     cStatement fallthrough
---

if [ ! -f ~/.env ]; then
	echo "export CFG_SCRIPT_DIR=$DIR" > ~/.env
fi

echo -n "Adding simlinks for dotFiles... "
ln -f -s $DIR/runcon/vimrc ~/.vimrc
ln -f -s $DIR/runcom/vim_ftplugin ~/.vim/ftplugin
ln -f -s $DIR/runcon/bashrc ~/.bashrc
ln -f -s $DIR/runcon/screenrc ~/.screenrc
ln -f -s $DIR/runcon/Xresources ~/.Xresources
ln -f -s $DIR/runcon/Xinitrc ~/.Xinitrc
ln -f -s $DIR/runcon/Xmodmap ~/.Xmodmap
ln -f -s $DIR/runcon/minttyrc ~/.minttyrc
ln -f -s $DIR/runcon/tmux.conf ~/.tmux.conf
ln -f -s $DIR/runcon/mbsyncrc ~/.mbsyncrc
ln -f -s $DIR/runcon/msmtprc ~/.msmtprc
echo "Done."

git config --global init.templatedir "$DIR/git_template"
git config --global rebase.autoSquash true
git config --global alias.ctags '!.git/hooks/ctags'
git config --global alias.last 'diff HEAD^ HEAD'
git config --global alias.su 'submodule update --recursive'
git config --global sendemail.confirm always
# For github PRs
git config --global alias.pr '!f() { git fetch -fu ${2:-$(git remote |grep ^upstream || echo origin)} refs/pull/$1/head:pr/$1 && git checkout pr/$1; }; f'
git config --global alias.pr-clean '!git for-each-ref refs/heads/pr/* --format="%(refname)" | while read ref ; do branch=${ref#refs/heads/} ; git branch -D $branch ; done'
# For stash/bitbucket
git config --global alias.spr '!f() { git fetch -fu ${2:-$(git remote |grep ^upstream || echo origin)} refs/pull-requests/$1/from:pr/$1 && git checkout pr/$1; }; f'
git config --global alias.fixup '!f() { git commit --all --fixup=$1; }; f'

touch ~/.ssh/config
if ! grep -qe 'Include .*/\.files/config/ssh_config' ~/.ssh/config; then
	echo "Adding default ssh_config."
	echo -e "Include $DIR/config/ssh_config\n" | cat - ~/.ssh/config > ~/.ssh/config.tmp && \
		mv ~/.ssh/config.tmp ~/.ssh/config
fi

echo -n "Adding custom scripts... "
mkdir -p ~/bin
cp -f -r scripts/* ~/bin/
echo "Done."

echo -n "Resourcing bashrc... "
source ~/.bashrc
echo "Done."

echo -e "\nFollowing are your favorite tools make sure you install them!"
cat $DIR/other/software.list

