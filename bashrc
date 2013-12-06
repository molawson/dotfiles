source ~/.bash/aliases
source ~/.bash/git-completion.bash

export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/bin:$PATH"
export RUBYLIB="/usr/local/lib:$RUBYLIB"
export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

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


better_git_prompt() {
  git_status="$(git status 2> /dev/null)"

  if [[ ${git_status} != "" ]]; then
    # Add characters based on unstaged/staged/untracked states.
    state=""
    if [[ ${git_status} =~ "Changes not staged" ]]; then
      state=$state"*" # unstaged changes
    fi
    if [[ ${git_status} =~ "Changes to be committed" ]]; then
      state=$state"+" # staged changes
    fi
    if [[ ${git_status} =~ "Untracked files" ]]; then
      state=$state"%" # untracked files
    fi

    if [[ ${state} != "" ]]; then
      state=" "$state
    fi

    # Set color based on status against remote.
    remote_pattern="Your branch is (.*)'"
    if [[ ${git_status} =~ ${remote_pattern} ]]; then
      match="${BASH_REMATCH[1]}"
      if [[ ${match} =~ "ahead" ]]; then
        remote="${GREEN}"
      elif [[ ${match} =~ "behind" ]]; then
        remote="${YELLOW}"
      elif [[ ${match} =~ "up-to-date" ]]; then
        remote="${BLUE}"
      fi
    else
      diverge_pattern="Your branch and (.*) have diverged"
      if [[ ${git_status} =~ ${diverge_pattern} ]]; then
        remote="${RED}"
      fi
    fi

    # Get the name of the branch.
    branch_pattern="On branch ([^${IFS}]*)"
    if [[ ${git_status} =~ ${branch_pattern} ]]; then
      branch=${BASH_REMATCH[1]}
    else
      git_tag="$(git describe --tags --exact-match 2> /dev/null)"
      if [[ ${git_tag} != "" ]]; then
        branch=${git_tag}
      else
        git_sha="$(git rev-parse --short HEAD 2> /dev/null)"
        branch=${git_sha}
      fi
    fi

    # Set the final branch string.
    git_prompt="(${remote}${branch}${state}${NORMAL})"
    echo ${git_prompt}
  fi
}



export PS1="\h:\W\$(better_git_prompt)$ "


# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# rt
eval "$($HOME/.rt/bin/rt init -)"

export PATH
