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

installZsh() {
  case $os in
    $macOS)
      brew install zsh
      ;;
    $ubuntu)
      sudo apt-get install -y zsh
      ;;
  esac
}

installOMZsh() {
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

installPackageManager() {
  case $os in
    $macOS)
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      ;;
    $ubuntu)
      sudo apt-get -y update
      ;;
  esac
}

installHub() {
  case $os in
    $macOS)
      brew install hub
      ;;
    $ubuntu)
      sudo apt-get -y install hub
      ln -s /usr/bin/hub /usr/local/bin/hub
      ;;
  esac
}

installJump() {
  case $os in
    $macOS)
      brew install jump
      ;;
    $ubuntu)
      go get github.com/gsamokovarov/jump
      ;;
  esac
}

installAg() {
  case $os in
    $macOS)
      brew install the_silver_searcher
      ;;
    $ubuntu)
      sudo apt-get -y install silversearcher-ag
      ;;
  esac
}

installGitsh() {
  case $os in
    $macOS)
      brew install gitsh
      ;;
    $ubuntu)
      curl -OL https://github.com/thoughtbot/gitsh/releases/download/v0.14/gitsh-0.14.tar.gz
      tar -zxvf gitsh-0.14.tar.gz
      cd gitsh-0.14
      ./configure
      make
      sudo make install
      cd ..
      rm -rf gitsh-0.14*
      ;;
  esac
}

installCtags() {
  case $os in
    $macOS)
      brew install ctags
      ;;
    $ubuntu)
      sudo apt-get -y install ctags
      ;;
  esac
}

installNeovim() {
  case $os in
    $macOS)
      brew install neovim
      ;;
    $ubuntu)
      sudo apt-get -y install neovim
      ln -s /usr/bin/nvim /usr/local/bin/nvim
      ;;
  esac
}

setupNeovim() {
  nvim -c "PlugInstall"
  ln -s $HOME/.vim/plugged/fzf/bin/fzf /usr/local/bin/fzf
  read e
  echo $e
}

echo "Running installation for $os..."
createPrivateFiles
# TODO: add me
# generateSSHKey
# generateGPGKey
# TODO: make these assumptions explicit
# installGit
# installGo
# installRuby (rbenv)
installZsh
installPackageManager
installHub
installJump
installAg
installGitsh
installCtags
installNeovim
# TODO: add me
# installTmux
intallOMZsh
(cd "$HOME/.dotfiles"; rake install)
setupNeovim
bin/bash "$HOME/.bin/ctags_init"
