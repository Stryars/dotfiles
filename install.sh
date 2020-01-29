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
  ln -sf ~/.config/git/gitconfig ~/.gitconfig

  # Make zsh the default shell 
  chsh -s $(which zsh)

  # Symlink zsh dotfiles
  ln -sf ~/.config/zsh/zshrc.zsh ~/.zshrc
  ln -sf ~/.config/zsh/zsh_plugins.zsh ~/.zsh_plugins

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
elif [[ $platform == 'Linux' ]]; then
  echo "Linux platforms not yet supported."
else
  echo "Only macOS and Linux platforms are supported."
fi

