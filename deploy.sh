#!/bin/bash

clone_repo() {
	base=$1
	url=$2
	repo_name=$(echo $url | perl -pe 's/.*\/(.*)$/\1/')
	dir_name=$(echo $repo_name | perl -pe 's/\.git$//')
	if [ ! -d $base/$dir_name ]; then
		echo "Cloning $repo_name to $base/$dir_name"
		git clone https://github.com/sidcha/$repo_name $base/$dir_name > /dev/null
		if [ $? -ne 0 ]; then
			echo "Could not find a fork; tracking upstream master"
			git clone $line $base/$dir_name > /dev/null
		fi
		git -C $base/$dir_name remote add upstream $line
	else
		git -C $base/$dir_name pull origin master
	fi
}

foreach_line() {
	list=$1; shift;
	while IFS='' read -r line || [[ -n "$line" ]]; do
		"$@" $line
	done < $list
}

#
# Note: This script should be re-runnable. ie., don't do any
# appends to files here.
#

DIR=$(realpath "$(dirname "$0")")
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

echo "Fectching new vim plugins.."
foreach_line $DIR/other/vim-plugin.list clone_repo ~/.vim/bundle

touch ~/.vim/spell/en.utf-8.add
rm -rf ~/.vim/syntax ~/.vim/ftplugin
mkdir -p ~/.config/nvim/

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
ln -f -s $DIR/runcon/zshrc ~/.zshrc
ln -f -s $DIR/runcon/neovim_init ~/.config/nvim/init.vim
ln -f -s $DIR/runcon/zshrc ~/.zshrc
ln -f -s $DIR/runcon/muttrc ~/.muttrc
echo "Done."

git config --global include.path $DIR/config/gitconfig
git config --global user.name "Siddharth Chandrasekaran"
git config --global init.templatedir "$DIR/git_template"
git config --global rebase.autoSquash true
git config --global sendemail.confirm always
git config --global am.threeWay true
git config --global color.ui auto
git config --global core.excludesfile ~/.gitignore
git config --global core.pager "less -FMRiX"

# Git alias
git config --global alias.ctags '!.git/hooks/ctags'
git config --global alias.last 'diff HEAD^ HEAD'
git config --global alias.su 'submodule update --recursive'
git config --global alias.ll 'log --format=%h --abbrev=12 --oneline'

# The patchset workflow:
#   All of the below git aliases operate on patch numbers (like the one git-format-patch
#   would give your patch). Some of them can take any git-ref too;
#
#   To see the all the patches made on current branch over beyond $base, run `git l`.
#   $base is set to origin/master by default. It can overridden by setting it in shell.
#
#   Aliases:
#     * git l - lists commits made on this branch with patch numbers
#     * git sh - show commit with patch number (or ref)
#     * git fixip - fixup commit with patch number
#     * git rb - rebase interactively autosquashing commits made on this branch
#     * git reword - reowrd the commit message of patch number
#     * git amend-to - merge the staged changes into the given patch number (or ref)
#
git config --global alias.l '!f() { base=${base:-origin/master}; git log --format=%h --abbrev=12 --oneline ${base}..HEAD | tac | nl | tac | perl -pe "s/([0-9a-f]{12})/\\e[1;31m\\1\\e[m/" | less -XFR; }; f'
git config --global alias.sh '!f() { base=${base:-origin/master}; sha="$(git rev-list --reverse ${base}..HEAD | sed -n -e ${1}p)"; git show $sha; }; f'
git config --global alias.fixup '!f() { base=${base:-origin/master}; if [ ${#1} -gt 5 ]; then sha="${1}"; else sha="$(git rev-list --reverse ${base}..HEAD | sed -n -e ${1}p)"; fi; git commit --fixup=$sha; }; f'
git config --global alias.rb '!f() { base=${base:-origin/master}; count=${1:-"$(git rev-list --reverse ${base}..HEAD | wc -l | xargs)"}; git rebase -i --autosquash HEAD~${count}; }; f'
git config --global alias.reword '!f() { base=${base:-origin/master}; sha="$(git rev-list --reverse ${base}..HEAD | sed -n -e ${1}p)"; git commit --fixup reword:${sha}; GIT_EDITOR=true git rebase -i --autosquash ${sha}^; }; f'
git config --global alias.amend-to '!f() { base=${base:-origin/master}; if [ ${#1} -gt 5 ]; then sha="${1}"; else sha="$(git rev-list --reverse ${base}..HEAD | sed -n -e ${1}p)"; fi; git commit --fixup=${sha} && GIT_EDITOR=true git rebase -i --autosquash ${sha}^; }; f'

# A Perl Compatible RE find and replace
git config --global alias.rp '!f() { find=${1}; shift; replace=${1}; shift; files="$*"; if test -z "${files}"; then files="$(git grep --perl-regexp -n "${find}" | perl -pe "s/:\d+:.*//" | uniq | tr "\n" " ")"; fi; if test -n "${files}"; then perl -i -pe "s/${find}/${replace}/g" $files; fi; }; f'

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

if [[ ! -d "$HOME/.fzf" ]]; then
	echo "Setting up fzf..."
	git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
	~/.fzf/install
fi

if [ ! -f ~/.env ]; then
	echo "export CFG_SCRIPT_DIR=$DIR" > ~/.env
fi

echo -n "Resourcing bashrc... "
source ~/.bashrc
echo "Done."

cat <<----

Following are your favorite tools make sure you install them!"
$(cat $DIR/other/software.list)

Also install parcellite and set the following:
	- Use copy (Ctrl-C)
	- Use Primary (Selection)
	- Sync clipboards
---
