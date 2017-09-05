function this_os_is(){
    case "${OSTYPE}" in
        linux*)
            OS="linux"
            ;;
        darwin*)
            OS="mac"
            ;;
        freebsd*)
            OS="bsd"
            ;;
    esac
    if [ "${OS}" = "$1" ]; then
        return 0
    fi
    return 1
}
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias zgrep='zgrep --color=auto'
alias zegrep='zegrep --color=auto'
alias zfgrep='zfgrep --color=auto'

# Vim
export LANG=ja_JP.UTF-8
alias dvi=/usr/bin/vi
alias vi=vim
if this_os_is mac; then
    if [ -x '/Applications/MacVim.app/Contents/MacOS/Vim' ]; then
        alias vim='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
        alias vi='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
    fi
    export EDITOR=vim
fi

if [ `this_os_is bsd` -o `this_os_is mac` ] ; then
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
export FIGNORE=${FIGNORE}:.meta

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
function switch_virtualenv() {
    if [[ $VIRTUAL_ENV != "" ]]; then
        venv="Py:${VIRTUAL_ENV##*/}"
    else
        venv=''
    fi
    echo -e "${venv}"
}
function switch_emo() {
    if [ $? -eq 0 ]; then
        emo="\[\033[00;31m\]('w')b\[\033[00m\] "
    else
        emo="\[\033[01;30;41m\]('m')q[\033[00m\] "
    fi
    echo -e "${emo}"
}
function __git_status_kanonji(){
    if ! type __gitdir > /dev/null 2>&1; then
        return
    fi
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
    venv="$(switch_virtualenv)"
    if type __git_ps1 > /dev/null 2>&1; then
        git_status_k="$(__git_status_kanonji)"
        PS1="\[\033[01;32m\]\u@\h\[\033[01;33m\] \w\$(__git_ps1) ${git_status_k}\n${venv} ${emo}\j \[\033[01;34m\]\$\[\033[00m\] "
    else
        PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n${emo}\j \$ "
    fi
}
# Ubuntuだと1回gitのsubcommandをTABで補完しないと__gitdirが定義されなかったので、ここで`_completion_loader git`して定義を試みる
if this_os_is linux; then
    if ! type __gitdir > /dev/null 2>&1; then
        if type _completion_loader > /dev/null 2>&1; then
            _completion_loader git
        fi
    fi
fi
PROMPT_COMMAND=_prompt_command

# anyenv
if type $HOME/.anyenv/bin/anyenv > /dev/null 2>&1 ; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
fi

if ! type $HOME/.anyenv/bin/anyenv > /dev/null 2>&1 ; then
# rbenv
  if type rbenv > /dev/null 2>&1 ; then
      eval "$(rbenv init -)"
  fi

# plenv
  if type plenv > /dev/null 2>&1 ; then eval "$(plenv init -)"; fi
fi

# nvm
if this_os_is mac; then
    if [ -d $HOME/.nvm ]; then
        export NVM_DIR=$HOME/.nvm
    fi
    if [ -s $NVM_DIR/nvm.sh ]; then
        source $NVM_DIR/nvm.sh
        alias npm-exec='PATH=$(npm bin):$PATH'
    fi
fi

## yarn
if [ -d $HOME/.yarn/bin ]; then export PATH="$HOME/.yarn/bin:$PATH"; fi

# php-nabe
if this_os_is mac; then
    if [ -d $HOME/.php-nabe/bin ]; then
        export PATH=$HOME/.php-nabe/bin:$PATH
    fi
fi

# pythonz
if [ -s $HOME/.pythonz/etc/bashrc ]; then
    source $HOME/.pythonz/etc/bashrc
    # if [ -s `which virtualenvwrapper.sh` -a -z "${WORKON_HOME}" ]; then
    #     source `which virtualenvwrapper.sh`
    #     export WORKON_HOME=$HOME/.virtualenvs
    #     export PROJECT_HOME=$HOME/dev/virtualenv
    #     eval "`pip completion --bash`"
    #     # export PIP_RESPECT_VIRTUALENV=true # globalに入れたpipでもvirtualenv環境で実行すればvirtualenv環境にインストールする。
    #     export PIP_REQUIRE_VIRTUALENV=true   # pipの実行はvirtualenv環境のみとする。Alternative to PIP_RESPECT_VIRTUALENV
    #
    #     workon default3
    #     alias mkvirtualenv="mkvirtualenv --python=\$(which python)"
    # fi
fi

# direnv
if type direnv > /dev/null 2>&1 ; then
    eval "$(direnv hook $0)"
fi

#aws-cli
if type aws > /dev/null 2>&1 ; then complete -C aws_completer aws; fi

# git-new-workdir
if this_os_is mac; then
    if [ ! -s $HOME/local/bin/git-new-workdir ]; then
        if [ -f $(brew --prefix git)/share/git-core/contrib/workdir/git-new-workdir ]; then
            ln -s $(brew --prefix git)/share/git-core/contrib/workdir/git-new-workdir $HOME/local/bin/git-new-workdir
        fi
    fi
fi

# webkit2png
if type webkit2png > /dev/null 2>&1 ; then
    alias webkit2png1280='webkit2png -C -s 1 --clipwidth=1280 --clipheight=720'
fi

###-begin-yo-completion-###
if type complete &>/dev/null; then
  _yo_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           yo-complete completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _yo_completion yo
fi
###-end-yo-completion-###
