function this_os_is(){
    case "${OSTYPE}" in
        linux*)
            OS="linux"
            ;;
        darwin*)
            OS="mac"
            ;;
    esac
    if [ "${OS}" = "$1" ]; then
        return 0
    fi
    return 1
}
export PATH=./vendor/bin:~/bin:$PATH
export GREP_OPTIONS='--color=auto'

# Vim
alias dvim='/usr/bin/vi'
if this_os_is mac; then
    if [ -x '/Applications/MacVim.app/Contents/MacOS/Vim' ]; then
        alias vim='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
        alias vi='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
    fi
fi

if this_os_is mac; then
    alias ls='ls -G'
fi
if this_os_is linux; then
    alias ls='ls --color --show-control-chars'
fi

# logout with ^D^D^D
export IGNOREEOF=3

# history
export HISTSIZE=5000
export HISTFILESIZE=5000
export HISTIGNORE=ls:pwd

# bash-completion
if this_os_is mac; then
    ## MacPorts
    if [ -f /opt/local/etc/bash_completion ]; then
        . /opt/local/etc/bash_completion
    fi
    ## homebrew
    if [ -f /usr/local/etc/bash_completion ]; then
        . /usr/local/etc/bash_completion
    fi
fi

# PS1 with git
if this_os_is mac; then
    ## MacPorts
    if [ -f /opt/local/share/git-core/git-prompt.sh ]; then
        . /opt/local/share/git-core/git-prompt.sh
    fi
    ## homebrew
    if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
        . /usr/local/etc/bash_completion.d/git-prompt.sh
    fi
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

# rbenv
if type rbenv > /dev/null 2>&1 ; then
    eval "$(rbenv init -)"
fi

# nvm
if this_os_is mac; then
    if [ -f $(brew --prefix nvm)/nvm.sh ]; then
        source $(brew --prefix nvm)/nvm.sh
    fi
fi

# php-nabe
if this_os_is mac; then
    if [ -d $HOME/.php-nabe/php-nabe/bin ]; then
        export PATH=$HOME/.php-nabe/php-nabe/bin:$PATH
    fi
fi

# pythonz
[[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc
