export PATH=~/bin:$PATH
export GREP_OPTIONS='--color=auto'
alias dvim='/usr/bin/vi'
#alias vim='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
#alias vi='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias ls='ls -G' #Mac
# alias ls='ls --color --show-control-chars' #Linux
export IGNOREEOF=3

# history
export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTIGNORE=ls:pwd

# PS1 with git
if [ -f /opt/local/share/git-core/git-prompt.sh ]; then
    . /opt/local/share/git-core/git-prompt.sh
fi
function switch_emo() {
    if [ $? -eq 0 ]; then
        emo="\033[00;31m(｀・ω・´)っ\033[00m"
    else
        emo="\033[01;30;41m( ´・ω・\\\`)っ\033[00m"
    fi
    echo -e "${emo}"
}
function _prompt_command(){
    emo="$(switch_emo)"
    if type __git_ps1 > /dev/null 2>&1; then
        PS1="\[\033[01;32m\]\u@\h\[\033[01;33m\] \w\$(__git_ps1) \n${emo}\j \[\033[01;34m\]\$\[\033[00m\] "
    else
        PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n${emo}\j \$ "
    fi
}
PROMPT_COMMAND=_prompt_command
