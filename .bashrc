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

# bash-completion
## MacPorts
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi
## homebrew
if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
    . /usr/local/etc/bash_completion.d/git-completion.bash
fi

# PS1 with git
## MacPorts
if [ -f /opt/local/share/git-core/git-prompt.sh ]; then
    . /opt/local/share/git-core/git-prompt.sh
fi
## homebrew
if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
    . /usr/local/etc/bash_completion.d/git-prompt.sh
fi
function switch_emo() {
    if [ $? -eq 0 ]; then
        emo="\[\033[00;31m\](｀・ω・´)っ\[\033[00m\]"
    else
        emo="\[\033[01;30;41m\]( ´・ω・\\\`)っ\[\033[00m\]"
    fi
    echo -e "${emo}"
}
function __git_status_k(){
    local g="$(__gitdir)";
    if [ -n "$g" ]; then
        local status=$(git status --porcelain 2>/dev/null)
        local staged=$(echo "$status" | grep "^M" | wc -l | tr -d ' ')
        local new=$(echo "$status" | grep "^A" | wc -l | tr -d ' ')
        local modified=$(echo "$status" | grep "^ M" | wc -l | tr -d ' ')
        local untracked=$(echo "$status" | grep "^??" | wc -l | tr -d ' ')
        echo -e "\[\033[0;32m\]Staged: \[\033[00m\]${staged}, \[\033[0;32m\]New file: \[\033[00m\]${new}, \[\033[0;31m\]Modified: \[\033[00m\]${modified}, \[\033[0;31m\]Untracked: \[\033[00m\]${untracked}"
    fi
}
function _prompt_command(){
    emo="$(switch_emo)"
    if type __git_ps1 > /dev/null 2>&1; then
        git_status_k="$(__git_status_k)"
        PS1="\[\033[01;32m\]\u@\h\[\033[01;33m\] \w\$(__git_ps1) ${git_status_k}\n${emo}\j \[\033[01;34m\]\$\[\033[00m\] "
    else
        PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n${emo}\j \$ "
    fi
}
PROMPT_COMMAND=_prompt_command
