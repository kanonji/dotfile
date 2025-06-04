# $ if this_os_is mac; then echo "yes"; fi
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

# https://github.com/microsoft/WSL/issues/4555#issuecomment-711091232
export WSL=no WSLVER=""
if [[ "$(< /proc/version)" = *[Mm]icrosoft* ]]; then
  WSL=yes
  if [[ -e "/proc/config.gz" ]]; then WSLVER+="2"; else WSLVER+="1"; fi
  if [[ -e "/dev/vsock" ]];      then WSLVER+="2"; else WSLVER+="1"; fi
  if [[ -n "$WSL_INTEROP" ]];    then WSLVER+="2"; else WSLVER+="1"; fi
  if [[ -d "/run/WSL" ]];        then WSLVER+="2"; else WSLVER+="1"; fi
  if [[ -n "${WSLVER//1/}" && -n "${WSLVER//2/}" ]]; then
    echo "WSL version detection got multiple answers ($WSLVER), time to update this code!"
  fi
  WSLVER="${WSLVER:0:1}"
fi

# $ if this_is_wsl; then echo "yes"; fi
function this_is_wsl(){
    if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
        return 0
    fi
    return 1
}
function this_is_wsl1(){
  if this_is_wsl && (($WSLVER==1)); then
    return 0
  fi
  return 1
}
function this_is_wsl2(){
  if this_is_wsl && (($WSLVER==2)); then
    return 0
  fi
  return 1
}
if this_is_wsl; then
  umask 022
fi

export PATH=$HOME/local/bin:$HOME/local/sbin:/usr/local/bin:/usr/local/sbin:$PATH
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
  echo "alias ls='ls -G'"
  alias ls='ls -G'
fi
if this_os_is linux; then
  echo "alias ls='ls --color --show-control-chars'"
  alias ls='ls --color --show-control-chars'
fi
if this_is_wsl2; then
  echo "alias wgit='git.exe'"
  alias wgit='git.exe'
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
        emo="\[\033[01;30;41m\]('m')q\[\033[00m\] "
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
        PS1="\[\033[01;32m\]\u@\h ${WSL_DISTRO_NAME}\[\033[01;33m\] \w\$(__git_ps1) ${git_status_k}\n${venv} ${emo}\j \[\033[01;34m\]\$\[\033[00m\] "
    else
        PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h ${WSL_DISTRO_NAME} \[\e[33m\]\w\[\e[0m\]\n${emo}\j \$ "
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

# Linuxbrew
if type /home/linuxbrew/.linuxbrew/bin/brew > /dev/null 2>&1; then
  echo "linuxbrew:"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# anyenv
if type $HOME/.anyenv/bin/anyenv > /dev/null 2>&1 ; then
  echo "anyenv:"
  echo 'eval "$(anyenv init -)"'
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
fi

## yarn
if [ -d $HOME/.yarn/bin ]; then export PATH="$HOME/.yarn/bin:$PATH"; fi

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
if this_is_wsl; then
    if [ ! -s $HOME/local/bin/git-new-workdir ]; then
        if [ -f /usr/share/doc/git/contrib/workdir/git-new-workdir ]; then
            ln -s /usr/share/doc/git/contrib/workdir/git-new-workdir $HOME/local/bin/git-new-workdir
        fi
    fi

fi

# webkit2png
if type webkit2png > /dev/null 2>&1 ; then
    alias webkit2png1280='webkit2png -C -s 1 --clipwidth=1280 --clipheight=720'
fi

# Docker
if this_is_wsl1; then
  if type docker-machine.exe > /dev/null 2>&1; then
     eval $(docker-machine.exe env --shell=bash)
  fi
  export DOCKER_CERT_PATH=${USERPROFILE}/.docker/machine/machines/default # `set WSLENV=USERPROFILE/up` on Windows env variable setting.
fi

# Golang
if type go > /dev/null 2>&1; then
  if [ -n "$(go env GOBIN)" ]; then
    echo "Golang: export PATH=\$(go env GOBIN):\$PATH"
    export PATH=$(go env GOBIN):$PATH
  else
    echo "Golang: export PATH=\$(go env GOPATH)/bin:\$PATH"
    export PATH=$(go env GOPATH)/bin:$PATH
  fi
fi

# Deprecated

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

if ! type $HOME/.anyenv/bin/anyenv > /dev/null 2>&1 ; then
# rbenv
  if type rbenv > /dev/null 2>&1 ; then
      eval "$(rbenv init -)"
  fi

# plenv
  if type plenv > /dev/null 2>&1 ; then eval "$(plenv init -)"; fi
fi
