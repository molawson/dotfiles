source ~/.bash/aliases
source ~/.bash/git-completion
source ~/.bash/git-prompt
source ~/.private


export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/bin:$PATH"
export RUBYLIB="/usr/local/lib:$RUBYLIB"
export SSL_CERT_FILE="/usr/local/etc/openssl/cert.pem"


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


export PS1="\h:\W\$(better_git_prompt)$ "


# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# ht
eval "$($HOME/.ht/bin/ht init -)"

export PATH

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
