# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias ip='ip --color=auto'
fi

# some more ls aliases
alias l.='ls -d *'
alias ll='ls -l --si -v --group-directories-first'
alias la='ls -A'
alias lla='ll -A'
alias l='ls -CF'

# verbose commands
alias mkdir='mkdir -p -v'
alias ln='ln -v'
alias rm='rm -v'
alias rmdir='rmdir -v'

# Use vim if possible instead of vi
if command -v vim > /dev/null; then
	alias vi='vim'
else
	alias vim='vi'
fi
alias e="${EDITOR:-vi}"

# Alias expansion in sudo arguments
alias sudo='sudo '

# Reload bashrc
alias bashreload="source ~/.bashrc"

# Always prefer Python3
alias python='python3'

# Easy calculator instead of bc
alias pc='python -ic "from __future__ import division; from math import *"'

# Moving around
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../../'

# Typos
alias dc='cd'
alias sl='ls'
alias gti='git'

# whatever
alias shrug="echo '¯\_(ツ)_/¯'"
alias pinguin="echo 🐧"
