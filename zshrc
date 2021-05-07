export PATH="$HOME/.bin:$PATH"

source "$HOME/.zsh/aliases"
source "$HOME/.private"

export GOPATH="$HOME/.go"
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/bin:$GOPATH/bin:$HOME/.bin:$PATH"

##
# DELUXE-USR-LOCAL-BIN-INSERT
# (do not remove this comment)
##
echo $PATH | grep -q -s "/usr/local/bin"
if [ $? -eq 1 ] ; then
    PATH=$PATH:/usr/local/bin
    export PATH
fi

ZSH_CUSTOM=$HOME/.zsh/custom
ZSH_THEME=robbyrussell
export ZSH=$HOME/.oh-my-zsh
DISABLE_AUTO_TITLE="true"

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1

plugins=(gitfast rails bundler rake-fast)

eval "$($HOME/Code/pco/bin/pco init -)"
eval "$(jump shell)"
eval "$(hub alias -s)"

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"

export PATH="node_modules/.bin:$PATH"

export EDITOR="nvim"

source $ZSH/oh-my-zsh.sh
export RBENV_ROOT=$HOME/.rbenv
eval "$(rbenv init -)"

export MYSQL_PORT_3306_TCP_ADDR=127.0.0.1
export MYSQL_READER_PORT_3306_TCP_ADDR=127.0.0.1
export MYSQL_READER_PORT_3306_TCP_PORT=3307
export PATH=$HOME/pco-box/bin:/usr/local/bin:$PATH
