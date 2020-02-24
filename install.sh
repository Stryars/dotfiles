#!/bin/sh

# Identify OS
platform='unknown'
unamestr=$(uname)
if [[ $unamestr == 'Linux' ]]; then
   platform='linux'
elif [[ $unamestr == 'Darwin' ]]; then
   platform='macOS'
fi

# macOS
if [[ $platform == 'macOS' ]]; then
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

  # Specify iTerm2 preference directory
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.config/iterm"
  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

  # Symlink Amethyst config
  ln -sf ~/.config/amethyst/amethyst ~/.amethyst

  # Symlink R Makevars
  mkdir ~/.R/
  ln -sf ~/.config/R/Makevars ~/.R/Makevars
elif [[ $platform == 'linux' ]]; then
  # Get os name
  osname=$(cat /etc/os-release | grep ^ID | sed -e 's/ID=//')
  versionid=$(cat /etc/os-release | grep ^VERSION_ID | sed -e 's/VERSION_ID=//')

  if [[ $osname == 'fedora' && $versionid -ge 22 ]]; then
    # Install packages
    sudo dnf update
    sudo dnf install -y git \
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
      pandoc

    # Install antibody (zsh plugin manager)
    curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin

    # Install zsh syntax highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      ~/.config/zsh/zsh-syntax-highlighting

    # Install diff-so-fancy
    sudo wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O /usr/local/bin/diff-so-fancy
  else
    echo "This script currently works for macos and Fedora 22+."
    exit
  fi

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

  # Symlink R Makevars
  mkdir ~/.R/
  ln -sf ~/.config/R/Makevars ~/.R/Makevars
else
  echo "Only macOS and Linux platforms are supported."
fi

