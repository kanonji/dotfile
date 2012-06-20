export PATH=~/bin:$PATH
export GREP_OPTIONS='--color=auto'
alias ls='ls -G' #Mac
# alias ls='ls --color --show-control-chars' #Linux

# history
export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTIGNORE=ls:pwd

# /etc/bash_completion.d/git
if [ -f $BASH_COMPLETION_DIR/git ]; then
    export PS1='\[\033[01;32m\]\u@\h\[\033[01;33m\] \w$(__git_ps1) \n\[\033[01;34m\]\$\[\033[00m\] '
else
    export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
fi
