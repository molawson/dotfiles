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

plugins=(gitfast rails bundler rake-fast)

export PATH="node_modules/.bin:$PATH"

export PATH="/opt/homebrew/bin:$PATH"

export EDITOR="nvim"

source $ZSH/oh-my-zsh.sh

export MYSQL_PORT_3306_TCP_ADDR=127.0.0.1
export MYSQL_READER_PORT_3306_TCP_ADDR=127.0.0.1
export MYSQL_READER_PORT_3306_TCP_PORT=3307
export PATH=$HOME/pco-box/bin:/usr/local/bin:$PATH

##
# DELUXE-USR-LOCAL-BIN-INSERT
# (do not remove this comment)
##
echo $PATH | grep -q -s "/usr/local/bin"
if [ $? -eq 1 ] ; then
    PATH=$PATH:/usr/local/bin
    export PATH
fi

export RBENV_ROOT=$HOME/.rbenv
eval "$(rbenv init -)"
eval "$($HOME/Code/pco/bin/pco init -)"
eval "$(jump shell)"
eval "$(hub alias -s)"
