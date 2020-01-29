export TERM=xterm-256color

export \
	LC_ALL=en_US.UTF-8 \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	EDITOR=vim \
  PATH=/opt/local/bin:/opt/local/sbin:/usr/local/sbin:/usr/local/bin:$PATH

# See https://stackoverflow.com/questions/58272830/python-crashing-on-macos-10-15-beta-19a582a-with-usr-lib-libcrypto-dylib
export DYLD_FALLBACK_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_LIBRARY_PATH

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=9"

# Load plugins via antibody
source <(antibody init)
antibody bundle < ~/.zsh_plugins

# Initialize prompt system
autoload -U promptinit; promptinit
prompt pure

# Enable vim mode in zsh
bindkey -v

# Aliases
alias ls='ls -G'
alias ll='ls -alhFG'
alias cat='bat --theme "Monokai Extended"'
alias ping='prettyping --nolegend'
alias preview="fzf --preview 'bat --color always {}'"
alias top="htop"
alias find='fd'
alias du="ncdu --color dark -rr -x"
alias help='tldr'
alias afk="open -a /System/Library/CoreServices/ScreenSaverEngine.app"
eval $(thefuck --alias)

# Load zsh syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
