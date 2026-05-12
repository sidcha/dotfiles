#!/usr/bin/env bash
#
# Note: This script should be re-runnable. ie., don't do any
# appends to files here.
#
set -euo pipefail
trap 's=$?; echo "ERROR: deploy.sh failed at line $LINENO (exit $s)" >&2' ERR

clone_repo() {
	local base=$1
	local url=$2
	local repo_name dir_name fork_url default_branch
	repo_name=$(echo "$url" | perl -pe 's/.*\/(.*)$/\1/')
	dir_name=$(echo "$repo_name" | perl -pe 's/\.git$//')
	fork_url="https://github.com/sidcha/$repo_name"

	if [ ! -d "$base/$dir_name" ]; then
		echo "Cloning $repo_name to $base/$dir_name"
		if git clone "$fork_url" "$base/$dir_name" >/dev/null 2>&1; then
			git -C "$base/$dir_name" remote add upstream "$url"
		else
			echo "Could not find a fork; tracking upstream directly"
			git clone "$url" "$base/$dir_name" >/dev/null
			git -C "$base/$dir_name" remote add upstream "$url" 2>/dev/null || true
		fi
	fi

	echo "Processing $repo_name in $base/$dir_name"
	# Discover upstream's default branch (master vs main vs ...) instead of
	# hard-coding "master", which breaks on repos that have migrated.
	git -C "$base/$dir_name" fetch upstream >/dev/null
	git -C "$base/$dir_name" remote set-head upstream --auto >/dev/null
	default_branch=$(git -C "$base/$dir_name" symbolic-ref --short refs/remotes/upstream/HEAD | sed 's@^upstream/@@')
	git -C "$base/$dir_name" pull upstream "$default_branch"

	# When .files itself is an ssh clone, also keep the forks pushable over ssh.
	if git remote get-url origin | grep -q '^git@github.com'; then
		git -C "$base/$dir_name" remote set-url origin \
			"$(echo "$fork_url" | perl -pe 's|^https://([^/]+)/(.*?)(\.git)?$|git@\1:\2.git|')"
		git -C "$base/$dir_name" push origin "$default_branch"
	fi
}

foreach_line() {
	local list=$1; shift
	local line
	while IFS='' read -r line || [[ -n "$line" ]]; do
		[ -z "$line" ] && continue
		"$@" "$line"
	done < "$list"
}

DIR=$(cd "$(dirname "$0")" && pwd)
pushd "$DIR" >/dev/null

if git diff --quiet --exit-code; then
	git pull origin master --rebase
else
	echo "Working tree is dirty! Will not git pull"
fi

mkdir -p ~/.vim/autoload ~/.vim/bundle ~/.vim/spell ~/.vim/syntax
mkdir -p ~/.config ~/.ssh

if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
	echo "Downloading pathogen for vim"
	curl -fsSLo ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

echo "Fetching new vim plugins..."
rm -rf ~/.vim/bundle/file-line/
foreach_line "$DIR/runcon/vim/plugin.list" clone_repo ~/.vim/bundle

touch ~/.vim/spell/en.utf-8.add
rm -rf ~/.vim/syntax ~/.vim/ftplugin

echo -n "Adding symlinks for dotfiles... "
ln -fs "$DIR/runcon/vim/vimrc"    ~/.vim/vimrc
ln -fs "$DIR/runcon/vim/ftplugin" ~/.vim/ftplugin
ln -fs "$DIR/runcon/vim/syntax"   ~/.vim/syntax
ln -fs "$DIR/runcon/bashrc"       ~/.bashrc
ln -fs "$DIR/runcon/screenrc"     ~/.screenrc
ln -fs "$DIR/runcon/Xresources"   ~/.Xresources
ln -fs "$DIR/runcon/Xinitrc"      ~/.Xinitrc
ln -fs "$DIR/runcon/Xmodmap"      ~/.Xmodmap
ln -fs "$DIR/runcon/minttyrc"     ~/.minttyrc
ln -fs "$DIR/runcon/mbsyncrc"     ~/.mbsyncrc
ln -fs "$DIR/runcon/msmtprc"      ~/.msmtprc
ln -fs "$DIR/runcon/zshrc"        ~/.zshrc
ln -fs "$DIR/runcon/nvim"         ~/.config/nvim
ln -fs "$DIR/runcon/alacritty"    ~/.config/alacritty
ln -fs "$DIR/runcon/tmux"         ~/.config/tmux
ln -fs "$DIR/runcon/mutt"         ~/.config/mutt
echo "Done."

git config --global include.path "$DIR/config/gitconfig"
git config --global user.name "Siddharth Chandrasekaran"
git config --global init.templatedir "$DIR/git_template"
git config --global rebase.autoSquash true
git config --global sendemail.confirm always
git config --global am.threeWay true
git config --global color.ui auto
git config --global core.excludesfile ~/.gitignore
git config --global core.pager "less -FMRiX"

# Git alias
git config --global alias.whatchanged 'log --stat'
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
git config --global alias.l        '!f() { base=${base:-$(git config repo.upstream)}; git log --format=%h --abbrev=12 --oneline ${base}..HEAD | tac | nl | tac | perl -pe "s/([0-9a-f]{12})/\\e[1;31m\\1\\e[m/" | less -XFR; }; f'
git config --global alias.sh       '!f() { base=${base:-$(git config repo.upstream)}; if [ ${#1} -gt 5 ]; then sha="${1}"; else sha="$(git rev-list --reverse ${base}..HEAD | sed -n -e ${1}p)"; fi; git show $sha; }; f'
git config --global alias.fixup    '!f() { base=${base:-$(git config repo.upstream)}; if [ ${#1} -gt 5 ]; then sha="${1}"; else sha="$(git rev-list --reverse ${base}..HEAD | sed -n -e ${1}p)"; fi; git commit --fixup=$sha; }; f'
git config --global alias.reword   '!f() { base=${base:-$(git config repo.upstream)}; if [ ${#1} -gt 5 ]; then sha="${1}"; else sha="$(git rev-list --reverse ${base}..HEAD | sed -n -e ${1}p)"; fi; git commit --fixup reword:${sha}; GIT_EDITOR=true git rebase -i --autosquash ${sha}^; }; f'
git config --global alias.amend-to '!f() { base=${base:-$(git config repo.upstream)}; if [ ${#1} -gt 5 ]; then sha="${1}"; else sha="$(git rev-list --reverse ${base}..HEAD | sed -n -e ${1}p)"; fi; git commit --fixup=${sha} && GIT_EDITOR=true git rebase -i --autosquash ${sha}^; }; f'
git config --global alias.rb       '!f() { base=${base:-$(git config repo.upstream)}; count=${1:-"$(git rev-list --reverse ${base}..HEAD | wc -l | xargs)"}; git rebase -i --autosquash HEAD~${count}; }; f'
git config --global alias.pref     '!f() { base=${base:-$(git config repo.upstream)}; sha="$(git rev-list --reverse ${base}..HEAD | sed -n -e ${1}p)"; echo ${sha} }; f'

# A Perl Compatible RE find and replace
git config --global alias.rp '!f() { find=${1}; shift; replace=${1}; shift; files="$*"; if test -z "${files}"; then files="$(git grep --perl-regexp -n "${find}" | perl -pe "s/:\d+:.*//" | uniq | tr "\n" " ")"; fi; if test -n "${files}"; then perl -i -pe "s/${find}/${replace}/g" $files; fi; }; f'

# For github PRs
git config --global alias.pr '!f() { git fetch -fu ${2:-$(git remote |grep ^upstream || echo origin)} refs/pull/$1/head:pr-$1 && git checkout pr-$1; }; f'
git config --global alias.pr-clean '!git for-each-ref refs/heads/pr-* --format="%(refname)" | while read ref ; do branch=${ref#refs/heads/} ; git branch -D $branch ; done'

# For stash/bitbucket
git config --global alias.spr '!f() { git fetch -fu ${2:-$(git remote |grep ^upstream || echo origin)} refs/pull-requests/$1/from:pr/$1 && git checkout pr/$1; }; f'

touch ~/.ssh/config
if ! grep -qe 'Include .*/\.files/config/ssh_config' ~/.ssh/config; then
	echo "Adding default ssh_config."
	{ echo -e "Include $DIR/config/ssh_config\n"; cat ~/.ssh/config; } > ~/.ssh/config.tmp
	mv ~/.ssh/config.tmp ~/.ssh/config
fi

if [[ ! -d "$HOME/.fzf" ]]; then
	echo "Setting up fzf..."
	git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
	"$HOME/.fzf/install" --all
fi

echo "Updating gdb-gef..."
curl -fsSL -o ~/.gdbinit-gef.py https://gef.blah.cat/py
touch ~/.gdbinit
# Strip any prior source line for .gdbinit-gef.py (the old script appended one
# every run, leaving duplicates with either ~ or $HOME expanded), then add it
# back exactly once.
grep -vF '.gdbinit-gef.py' ~/.gdbinit > ~/.gdbinit.tmp || true
echo 'source ~/.gdbinit-gef.py' >> ~/.gdbinit.tmp
mv ~/.gdbinit.tmp ~/.gdbinit

echo -n "Adding custom fonts... "
if [[ "$OSTYPE" == darwin* ]]; then
	# macOS picks up fonts automatically; just link each one into ~/Library/Fonts.
	mkdir -p ~/Library/Fonts
	for f in "$DIR"/fonts/*.[ot]tf; do
		[ -e "$f" ] && ln -fs "$f" ~/Library/Fonts/
	done
else
	ln -fs "$DIR/fonts" ~/.fonts
	if command -v fc-cache >/dev/null 2>&1; then
		fc-cache -f
	else
		echo -n "(fc-cache not found, skipping cache rebuild) "
	fi
fi
echo "Done."

if [ ! -f ~/.env ]; then
	echo "export CFG_SCRIPT_DIR=$DIR" > ~/.env
fi

cat <<EOF

Following are your favorite tools, make sure you install them!
$(cat "$DIR/other/software.list")

Also install parcellite and set the following:
	- Use copy (Ctrl-C)
	- Use Primary (Selection)
	- Sync clipboards
EOF
