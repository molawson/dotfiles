export PATH="$HOME/.bin:$PATH"

source "$HOME/.zsh/aliases"
source "$HOME/.private"

export PATH="$HOME/.bin:$PATH"

export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

ZSH_CUSTOM=$HOME/.zsh/custom
ZSH_THEME=robbyrussell
export ZSH=$HOME/.oh-my-zsh
DISABLE_AUTO_TITLE="true"

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1

plugins=(
    asdf
    bundler
    direnv
    gitfast
    rails
    rake-fast
)

export PATH="node_modules/.bin:$PATH"

if [ -d "/opt/homebrew" ]; then 
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export PATH="$(brew --prefix git)/share/git-core/contrib/diff-highlight:$PATH"

export EDITOR="nvim"

source $ZSH/oh-my-zsh.sh

if [[ -d $HOME/pco-box ]]; then
    source $HOME/pco-box/env.sh
fi

##
# DELUXE-USR-LOCAL-BIN-INSERT
# (do not remove this comment)
##
echo $PATH | grep -q -s "/usr/local/bin"
if [ $? -eq 1 ] ; then
    PATH=$PATH:/usr/local/bin
    export PATH
fi

eval "$($HOME/Code/pco/bin/pco init -)"
eval "$(jump shell)"
eval "$(hub alias -s)"
