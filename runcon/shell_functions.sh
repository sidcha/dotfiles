
# ectrat any archive files
extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)   tar xvjf $1    ;;
			*.tar.gz)    tar xvzf $1    ;;
			*.bz2)       bunzip2 $1     ;;
			*.rar)       unrar x $1     ;;
			*.gz)        gunzip $1      ;;
			*.tar)       tar xvf $1     ;;
			*.tbz2)      tar xvjf $1    ;;
			*.tar.gz)    tar xvzf $1    ;;
			*.tgz)       tar xvzf $1    ;;
			*.zip)       unzip $1       ;;
			*.Z)         uncompress $1  ;;
			*.7z)        7z x $1        ;;
			*)           echo "don't know how to extract '$1'..." ;;
			esac
		else
			echo "'$1' is not a valid file!"
	fi
}

termtitle() { printf "\033]0;$*\007"; }

# move up 3 levels in direcotries with up 3
up() { cd $(eval printf '../'%.0s {1..$1}); }

# Genrerate random passwords
randpwd() { (head -c 32 /dev/urandom | sha256sum | base64 | head -c 16 && echo""); }

get() {
	fc -lnr -$1 -$1 | sed -e 's/^\s*//'
}

edit() { sublime $1 & }

# Kill all detached screens only.
killscreens () {
	screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill
}

ascii() {
	man ascii | grep --color=never -B3 -A1 '[A-F0-9]:'
}

gdiff() {
	diff -Naurp $@ | perl -pe '
		if (/^\+\+\+ /) { $f="b" } else { $f="a" }
		s!^(---|\+\+\+)\s+(\S*?/)?(\S+)\s.*$!\1 $f/\3!;
	' | colordiff | less -FXR
}

dissac() {
	OD=${OBJDUMP:-objdump}
	${OD} -M Intel -D $1 | c++filt | less -FXR
}
