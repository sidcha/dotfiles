#!/bin/bash

DIR=$(realpath "$(dirname "$(readlink -f "$0")")")
pushd ${DIR} 2>&1 > /dev/null

if [[ -z "$(git diff --quiet --exit-code || echo +)" ]]; then
	git pull origin master
else
	echo "Working tree is dirty! Will not git pull"
fi

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
	else
		git -C $dir_name pull origin master
	fi
done < $DIR/other/vim-plugin.list
cd - > /dev/null

if [ ! -f ~/.env ]; then
	echo "export CFG_SCRIPT_DIR=$DIR" > ~/.env
fi

rm -rf ~/.vim/syntax ~/.vim/ftplugin

echo -n "Adding simlinks for dotFiles... "
ln -f -s $DIR/runcon/vim/vimrc ~/.vimrc
ln -f -s $DIR/runcon/vim/ftplugin ~/.vim/ftplugin
ln -f -s $DIR/runcon/vim/syntax ~/.vim/syntax
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

git config --global user.name "Siddharth Chandrasekaran"
git config --global init.templatedir "$DIR/git_template"
git config --global rebase.autoSquash true
git config --global sendemail.confirm always
git config --global am.threeWay true
git config --global core.excludesfile ~/.gitignore

# Git alias
git config --global alias.ctags '!.git/hooks/ctags'
git config --global alias.last 'diff HEAD^ HEAD'
git config --global alias.su 'submodule update --recursive'
git config --global alias.ll 'log --format=%h --abbrev=12 --oneline'
git config --global alias.l '!f() { git log --format=%h --abbrev=12 --oneline origin/master..HEAD | tac | nl | tac | perl -pe "s/([0-9a-f]{12})/\\e[1;31m\\1\\e[m/"; }; f'
git config --global alias.fixup '!f() { h="$(git rev-list --reverse origin/master..HEAD | sed -n -e ${1}p)"; git commit --fixup=$h; }; f'
git config --global alias.rb '!f() { count=${1:-"$(git rev-list --reverse origin/master..HEAD | wc -l)"}; git rebase -i --autosquash HEAD~${count}; }; f'
# For github PRs
git config --global alias.pr '!f() { git fetch -fu ${2:-$(git remote |grep ^upstream || echo origin)} refs/pull/$1/head:pr/$1 && git checkout pr/$1; }; f'
git config --global alias.pr-clean '!git for-each-ref refs/heads/pr/* --format="%(refname)" | while read ref ; do branch=${ref#refs/heads/} ; git branch -D $branch ; done'
# For stash/bitbucket
git config --global alias.spr '!f() { git fetch -fu ${2:-$(git remote |grep ^upstream || echo origin)} refs/pull-requests/$1/from:pr/$1 && git checkout pr/$1; }; f'

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

if [[ ! -d "$HOME/.fzf" ]]; then
	echo "Setting up fzf..."
	git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
	~/.fzf/install
fi

cat <<----

Following are your favorite tools make sure you install them!"
$(cat $DIR/other/software.list)

Also install parcellite and set the following:
	- Use copy (Ctrl-C)
	- Use Primary (Selection)
	- Sync clipboards
---

