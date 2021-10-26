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

installGit() {
  case $os in
    $macOS)
      brew install git
      ;;
    $ubuntu)
      sudo apt-get -y install git-all
      ;;
  esac
}

installTig() {

  case $os in
    $macOS)
      brew install tig
      ;;
    $ubuntu)
      if ! command -v tig >/dev/null 2>&1; then
        wget -O tig-2.5.4.tar.gz "https://github.com/jonas/tig/releases/download/tig-2.5.4/tig-2.5.4.tar.gz"
        tar -xvf tig-2.5.4.tar.gz
        cd tig-2.5.4 || exit
        make prefix=/usr/local
        sudo make install prefix=/usr/local
        cd ..
        rm -rf tig-2.5.4
        rm tig-2.5.4.tar.gz
      fi
      ;;
  esac
}

installGo() {
  case $os in
    $macOS)
      brew install go
      ;;
    $ubuntu)
      sudo apt-get -y install golang-go
      ;;
  esac
}

installRuby() {
  case $os in
    $macOS)
      brew install rbenv
      ;;
    $ubuntu)
      sudo apt-get -y install rbenv
      ;;
  esac

  mkdir -p "$(rbenv root)/plugins"
  git clone git://github.com/tpope/rbenv-aliases.git "$(rbenv root)/plugins/rbenv-aliases"
  rbenv alias --auto

  rbenv install 2.7
  rbenv global 2.7
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

installTmux() {
  case $os in
    $macOS)
      brew install tmux
      fixTmux256ColorTerm
      ;;
    $ubuntu)
      sudo apt-get -y install tmux
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
installPackageManager
installGpg
installGit
installGo
installRuby
installZsh
installHub
installJump
installAg
installGitsh
installTig
installCtags
installNeovim
installTmux
installOMZsh
(cd "$HOME/.dotfiles"; rake install)
setupNeovim
bin/bash "$HOME/.bin/ctags_init"
