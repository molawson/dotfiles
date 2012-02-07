source ~/.bash/aliases

export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/bin:$PATH"
export RUBYLIB="/usr/local/lib:$RUBYLIB"

export CLICOLOR=1

##
# DELUXE-USR-LOCAL-BIN-INSERT
# (do not remove this comment)
##
echo $PATH | grep -q -s "/usr/local/bin"
if [ $? -eq 1 ] ; then
    PATH=$PATH:/usr/local/bin
    export PATH
fi

parse_git_branch ()
{
        if git rev-parse --git-dir >/dev/null 2>&1
        then
            origin=$(git config -l | grep remote.origin.url | sed -e 's/remote.origin.url=//g')
            if [ "$origin" = 'git@github.com:molawson/dotfiles.git' ]
            then
                gitver=''
            else
                gitver=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
                gitver='['$gitver']'
            fi
        else
                return 0
        fi
        echo $gitver
}

export PS1="\w\$(parse_git_branch)$ "

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export PATH=/opt/subversion/bin:$PATH

export PATH
