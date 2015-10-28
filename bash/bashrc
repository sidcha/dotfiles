# Aliases that makes life simple.
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias picocom='sudo picocom --omap crcrlf'
alias minicom='sudo minicom'
alias byebye='sudo shutdown -P now'
alias py='python3.4'
alias sl='ls'

#Start Screen at terminal session
#screen -R -d

# ectrat any archive files
extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)   tar xvjf $1    ;;
			*.tar.gz)    tar xvzf $1    ;;
			*.bz2)       bunzip2 $1     ;;
			*.rar)       unrar x $1       ;;
			*.gz)        gunzip $1      ;;
			*.tar)       tar xvf $1     ;;
			*.tbz2)      tar xvjf $1    ;;
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

# move up 3 levels in direcotries with up 3
up() { cd $(eval printf '../'%.0s {1..$1}); }

# Genrerate random passwords
randpwd() { (head -c 32 /dev/urandom | sha256sum | base64 | head -c 16 && echo""); }
