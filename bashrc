alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias picocom='sudo picocom --omap crcrlf'
alias minicom='sudo minicom'
alias byebye='sudo shutdown -P now'
alias py='python3.4'

# Generate random passwords
randpw(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;}
