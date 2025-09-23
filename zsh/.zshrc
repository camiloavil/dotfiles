#Setting $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
# load ~/.local/bin to PATH
export PATH="$PATH:$HOME/.local/bin"

# Set TERM to xterm-256color
export TERM=xterm-256color

# Set editor to nvim
export EDITOR=nvim
export VISUAL=nvim

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::python
zinit snippet OMZP::history
zinit snippet OMZP::rsync
zinit snippet OMZP::gitignore
zinit snippet OMZP::npm
zinit snippet OMZP::nmap
zinit snippet OMZP::docker
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
# Emacs mode 
# bindkey -e
# bindkey '^p' history-search-backward
# bindkey '^n' history-search-forward
# bindkey '^[w' kill-region

# Vi mode
bindkey -v
export VI_MODE_SET_CURSOR=true
# Configure keybindings in Vi normal mode
bindkey -M vicmd 'k' history-search-backward  # Use 'k' to search backward in history
bindkey -M vicmd 'j' history-search-forward   # Use 'j' to search forward in history
bindkey -M vicmd 'ff' clear-screen


# Configure keybindings in Vi insert mode
bindkey -M viins '^f' autosuggest-accept  # Use 'Ctrl + f' to accept autosuggestions in Vi insert mode
bindkey -M viins '^p' history-search-backward # Use 'Ctrl + p' to search backward in history
bindkey -M viins '^n' history-search-forward  # Use 'Ctrl + n' to search forward in history
bindkey -M viins 'jj' vi-cmd-mode  # Use 'jj' to exit insert mode in Vi
bindkey -M viins 'ff' clear-screen

# History
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt share_history
setopt inc_append_history
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt EXTENDED_HISTORY

# Prefijos de comandos que NO deben guardarse en el historial
IGNORED_HISTORY_PREFIXES=("ll" "llm" "oci")

zshaddhistory() {
  local cmd=$1
  # 1. Omitir si empieza con prefijo ignorado
  for prefix in "${IGNORED_HISTORY_PREFIXES[@]}"; do
    if [[ $cmd == ${prefix}* ]]; then
      return 1
    fi
  done
  # 2. Omitir si contiene salto de línea (multilínea)
  if [[ $cmd == *$'\n'* ]]; then
    return 1
  fi
  return 0  # guardar normalmente
}

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Validate Tools
source ~/.zsh/zsh_validations

# load functions
source ~/.zsh/scripts/load_functions.sh

# Load aliases
source ~/.zsh/zsh_alias

#Sesh Integration
source ~/.zsh/zsh_sesh
# StarShip
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
#Zoxide
eval "$(zoxide init zsh)"
#UV python completions
eval "$(uv generate-shell-completion zsh)"
#loads NVM directory to path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Add oci cli oracle-cli to path
export PATH=/home/camilo/.oci/bin:$PATH
[[ -e "/home/camilo/.oci/lib/oracle-cli/lib/python3.12/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "/home/camilo/.oci/lib/oracle-cli/lib/python3.12/site-packages/oci_cli/bin/oci_autocomplete.sh"

#alias python = "uv run python"
#alias pip = "uv pip"

