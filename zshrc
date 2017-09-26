export PATH="$HOME/.bin:$PATH"

source "$HOME/.zsh/aliases"

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

plugins=(gitfast)

eval "$($HOME/.pco/bin/pco init -)"
eval "$(jump shell)"

source $ZSH/oh-my-zsh.sh
