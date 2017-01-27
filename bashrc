source ~/.bash/aliases
source ~/.bash/git-completion
source ~/.bash/git-prompt
source ~/.bash/pcomux
source ~/.private

export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/bin:$HOME/bin:$PATH"
export RUBYLIB="/usr/local/lib:$RUBYLIB"
# export SSL_CERT_FILE="/usr/local/etc/openssl/cert.pem"

export SHOW_ALL_SERVERS=true

##
# DELUXE-USR-LOCAL-BIN-INSERT
# (do not remove this comment)
##
echo $PATH | grep -q -s "/usr/local/bin"
if [ $? -eq 1 ] ; then
    PATH=$PATH:/usr/local/bin
    export PATH
fi

# Use vim key bindings in bash prompts
set -o vi

# Alias git to hub
eval "$(hub alias -s)"

export PS1="\h:\W\$(better_git_prompt)$ "

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# pco
eval "$($HOME/.pco/bin/pco init -)"

# jump
eval "$(jump shell bash)"

export PATH

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# added by travis gem
[ -f /Users/molawson/.travis/travis.sh ] && source /Users/molawson/.travis/travis.sh
