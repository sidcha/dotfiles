
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    export CLICOLOR=1
fi

# Aliases that makes life simple.
if [[ "$(uname)" == "Linux" ]]; then
	alias ls='ls --color=auto'
else
	alias ls='ls -G'
fi

# Notify when a long-running command finishes:  sleep 10; alert
if command -v notify-send >/dev/null 2>&1; then
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
elif command -v osascript >/dev/null 2>&1; then
	alias alert='osascript -e "display notification \"$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')\" with title \"Terminal\""'
fi

alias ll='ls -la'
alias gcc='gcc -Wall'
alias gst='git status'
alias gdf='git diff'
alias gdfc='git diff --cached'
if command -v ip >/dev/null 2>&1; then
	alias iface='ip -br link'
else
	alias iface='ifconfig -s | sed 1d | cut -d" " -f1'
fi
alias rm_lines=' perl -ne '\'' system("rm -rf $_"); '\'' '
if command -v rg >/dev/null 2>&1; then
	alias gg='rg --no-heading --line-number'
fi
alias syslog='sudo tail -f /var/log/kern.log | perl -pe '\'' s/.*kernel: \[\d+\.\d+\] //; '\'' '

# Switch between https and ssh git remotes
alias git-ssh=' git remote set-url origin $( git remote get-url origin | perl -pe '\'' s|^https://([^/]+)/(.+)(\.git)?$|git@\1:\2.git| '\'' )'
alias git-http='git remote set-url origin $( git remote get-url origin | perl -pe '\'' s|^git@(.*):/?(.+)\.git$|https://\1/\2.git|      '\'' )'

# git format patch numbered
alias gfp_num='git format-patch --numbered --numbered-files'
# get commit message from git-format-patch files.
alias gfp_cmsg=' perl -ne '\'' last if (/^---$/); $p=1 if (s/^Subject: (\[.+\] )?//); print if $p '\'' '
