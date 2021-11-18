#!/bin/bash

macOS="macOS"
ubuntu="ubuntu"
uname=$(uname -v)

if [[ $uname == *Darwin* ]]
then
  os=$macOS
elif [[ $uname == *Ubuntu* ]]
then
  os=$ubuntu
else
  echo "ERROR: Don't know how to handle this OS"
  exit 1
fi

createPrivateFiles() {
  touch $HOME/.private
  touch $HOME/.gitconfig_private
}

installOMZsh() {
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

installHomebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew bundle
}

installGpg() {
  case $os in
    $macOS)
      brew install --cask gpg-suite-no-mail
      ;;
    $ubuntu)
      sudo apt-get -y install gnupg
      ;;
  esac
}

setupRbenv() {
  mkdir -p "$(rbenv root)/plugins"
  git clone git://github.com/tpope/rbenv-aliases.git "$(rbenv root)/plugins/rbenv-aliases"
  rbenv alias --auto

  rbenv install 2.7
  rbenv global 2.7
}

setupNeovim() {
  nvim --headless +PlugInstall +qall
  ln -s $HOME/.vim/plugged/fzf/bin/fzf /usr/local/bin/fzf
}

setupOS() {
  case $os in
    $macOS)
      ;;
    $ubuntu)
      sudo timedatectl set-timezone America/Chicago
      ;;
  esac
}

fixTmux256ColorTerm() {
  curl -OL https://gist.githubusercontent.com/nicm/ea9cf3c93f22e0246ec858122d9abea1/raw/37ae29fc86e88b48dbc8a674478ad3e7a009f357/tmux-256color
  echo '8f259a31649900b9a8f71cbc28be762aa55206316d33d51fd8d08e4275b5f6a3  tmux-256color' | shasum -a 256 -c
  if [ $? == 0 ]
  then
    /usr/bin/tic -x tmux-256color
  else
    echo 'tmux-256color checksum has changed'
  fi
  rm tmux-256color
}

echo "Running installation for $os..."
createPrivateFiles
installHomebrew
installGpg
installOMZsh
(cd "$HOME/.dotfiles"; rake install)
setupRbenv
setupNeovim
fixTmux256ColorTerm
/bin/bash "$HOME/.bin/ctags_init"
setupOS
