#!/bin/bash

# Identify OS
platform='unknown'
unamestr=$(uname)
if [[ $unamestr == 'Linux' ]]; then
   platform='linux'
elif [[ $unamestr == 'Darwin' ]]; then
   platform='macos'
fi

# macOS
if [[ $platform == 'macos' ]]; then
  # Install Homebrew if not found on system
  if test ! $(which brew); then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  # Update Homebrew recipes
  brew update

  # Install all formulas
  brew bundle

  # Symlink .gitconfig
  ln -sf ~/.config/git/gitconfig.macos ~/.gitconfig

  # Make zsh the default shell 
  chsh -s $(which zsh)

  # Install zsh syntax highlighting
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ~/.config/zsh/zsh-syntax-highlighting

  # Symlink zsh dotfiles
  ln -sf ~/.config/zsh/zshrc ~/.zshrc
  ln -sf ~/.config/zsh/zsh_plugins ~/.zsh_plugins

  # Symlink vimrc
  ln -sf ~/.config/vim/vimrc ~/.vimrc

  # Symlink UltiSnips snippets
  mkdir -p ~/.vim/UltiSnips/
  ln -sf ~/.config/vim/UltiSnips/* ~/.vim/UltiSnips/

  # Symlink tmux.conf
  ln -sf ~/.config/tmux/tmux.conf ~/.tmux.conf

  # Specify iTerm2 preference directory
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.config/iterm2"
  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

  # Symlink Amethyst config
  ln -sf ~/.config/amethyst/amethyst ~/.amethyst

  # Symlink R Makevars
  mkdir ~/.R/
  ln -sf ~/.config/R/Makevars ~/.R/Makevars
elif [[ $platform == 'linux' ]]; then
  # Get os name
  osname=$(cat /etc/os-release | grep ^ID= | sed -e 's/ID=//')
  versionid=$(cat /etc/os-release | grep ^VERSION_ID= | sed -e 's/VERSION_ID=//')

  if [[ $osname == 'fedora' && $versionid -ge 22 ]]; then
    # Install packages
    sudo dnf update
    sudo dnf groupinstall "Development Tools"
    sudo dnf install -y git \
      vim \
      R \
      util-linux-user \
      zsh \
      neofetch \
      thefuck \
      prettyping \
      bat \
      fzf \
      tmux \
      tldr \
      htop \
      asciinema \
      ImageMagick \
      pandoc \
      tilix
  elif [[ $osname == 'ubuntu' ]]; then
    # Install packages
    sudo apt update
    sudo apt install -y build-essential \
      curl \
      git \
      vim \
      r-base \
      zsh \
      neofetch \
      thefuck \
      tmux \
      tldr \
      htop \
      asciinema \
      imagemagick \
      pandoc \
      tilix

    # Installing prettyping
    sudo wget https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping -O /usr/local/bin/prettyping
    sudo chmod +x /usr/local/bin/prettyping

    # Installing bat
    wget https://github.com/sharkdp/bat/releases/download/v0.12.1/bat_0.12.1_amd64.deb
    sudo dpkg -i bat_0.12.1_amd64.deb
    rm bat_0.12.1_amd64.deb
  else
    echo "This script currently works for macOS, Fedora 22+ and Ubuntu 16.04+."
    exit
  fi

  # Install Anaconda
  wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
  chmod +x Anaconda3-2019.10-Linux-x86_64.sh
  ./Anaconda3-2019.10-Linux-x86_64.sh

  # Installing fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install

  # Install diff-so-fancy
  sudo wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O /usr/local/bin/diff-so-fancy
  sudo chmod +x /usr/local/bin/diff-so-fancy

  # Install antibody (zsh plugin manager)
  curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin

  # Install zsh syntax highlighting
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
	  ~/.config/zsh/zsh-syntax-highlighting

  # Symlink .gitconfig
  ln -sf ~/.config/git/gitconfig.linux ~/.gitconfig

  # Make zsh the default shell 
  chsh -s $(which zsh)

  # Symlink zsh dotfiles
  ln -sf ~/.config/zsh/zshrc ~/.zshrc
  ln -sf ~/.config/zsh/zsh_plugins ~/.zsh_plugins

  # Symlink vimrc
  ln -sf ~/.config/vim/vimrc ~/.vimrc

  # Symlink UltiSnips snippets
  mkdir -p ~/.vim/UltiSnips/
  ln -sf ~/.config/vim/UltiSnips/* ~/.vim/UltiSnips/

  # Symlink tmux.conf
  ln -sf ~/.config/tmux/tmux.conf ~/.tmux.conf

  # Symlink R Makevars
  mkdir ~/.R/
  ln -sf ~/.config/R/Makevars ~/.R/Makevars
else
  echo "Only macOS and Linux platforms are supported."
fi

