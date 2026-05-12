
# extract any archive files
extract() {
	if [ -f "$1" ]; then
		case "$1" in
			*.tar.bz2)   tar xvjf "$1"    ;;
			*.tar.gz)    tar xvzf "$1"    ;;
			*.bz2)       bunzip2 "$1"     ;;
			*.rar)       unrar x "$1"     ;;
			*.gz)        gunzip "$1"      ;;
			*.tar)       tar xvf "$1"     ;;
			*.tbz2)      tar xvjf "$1"    ;;
			*.tgz)       tar xvzf "$1"    ;;
			*.zip)       unzip "$1"       ;;
			*.Z)         uncompress "$1"  ;;
			*.7z)        7z x "$1"        ;;
			*)           echo "don't know how to extract '$1'..." ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}

termtitle() { printf "\033]0;%s\007" "$*"; }

# move up N levels in the directory tree: `up 3`
up() {
	local n=${1:-1} i path=""
	for ((i = 0; i < n; i++)); do path="../$path"; done
	cd "$path" || return
}

# Generate a random password
randpwd() {
	head -c 32 /dev/urandom | sha256sum | base64 | head -c 16
	echo
}

get() {
	fc -lnr -"$1" -"$1" | sed -e 's/^\s*//'
}

# Open a file in $EDITOR (falls back to vim) in the background.
edit() {
	"${EDITOR:-vim}" "$1" &
}

# Kill all detached screens.
killscreens() {
	screen -ls \
		| awk '/Detached/ { sub(/^[ \t]+/, "", $1); print $1 }' \
		| while IFS= read -r session; do
			[ -n "$session" ] && screen -S "$session" -X quit
		done
}

ascii() {
	man ascii | grep --color=never -B3 -A1 '[A-F0-9]:'
}

gdiff() {
	local colorize='cat'
	if command -v colordiff >/dev/null 2>&1; then
		colorize='colordiff'
	fi
	diff -Naurp "$@" | perl -pe '
		if (/^\+\+\+ /) { $f="b" } else { $f="a" }
		s!^(---|\+\+\+)\s+(\S*?/)?(\S+)\s.*$!\1 $f/\3!;
	' | "$colorize" | less -FXR
}

dissac() {
	local od=${OBJDUMP:-objdump}
	"$od" -M Intel -D "$1" | c++filt | less -FXR
}
