export PATH="$HOME/.bin:$PATH"

source "$HOME/.zsh/aliases"

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1

plugins=(gitfast rails bundler rake-fast)

eval "$($HOME/.pco/bin/pco init -)"
eval "$(jump shell)"

source $ZSH/oh-my-zsh.sh
