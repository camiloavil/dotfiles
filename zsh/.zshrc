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
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
#zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Set TERM to xterm-256color
export TERM=xterm-256color

#Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#Zoxide
eval "$(zoxide init zsh)"
#UV python completions
eval "$(uv generate-shell-completion zsh)"

# User configuration

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Example aliases
alias c="clear"
alias nv="nvim"
alias vim="nvim"
alias lg="lazygit"
alias vpnStop="sudo systemctl stop 'wg-quick@*'"
alias vpnKmiP="sudo systemctl start wg-quick@KmiPersonal.service"
alias vpnRpi="sudo systemctl start wg-quick@laptop_rpi.service"
# Aliaa pass
alias po="pass otp -c "
alias pa="pass -c "
# Alias llm
alias l="llm"
alias lc="llm -c"
alias le="llm -t english"
alias ac="autocommit"
alias autocommit="( git diff --cached | llm -t gcommit > /tmp/commit.txt && less /tmp/commit.txt && (cat /tmp/commit.txt | xargs git commit -m)) && rm /tmp/commit.txt"
# alias autocommit="( git diff --cached | llm -t gcommit > /tmp/commit.txt && less /tmp/commit.txt && (git commit -m '$(cat /tmp/commit.txt)') && rm /tmp/commit.txt"


#Sesh Integration
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡ Sessions')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}
zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

#loads NVM directory to path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
# load ~/.local/bin to PATH
export PATH="$PATH:$HOME/.local/bin"
#load Zig to Path
export PATH="$PATH:$HOME/.local/zig-linux-x86_64-0.13.0"
#load Ghostty to Path
export PATH="$PATH:$HOME/.local/ghostty/zig-out/bin/"

#
# load OPENAI_API_KEY
if [[ -z "${OPENAI_API_KEY}" ]]; then
    export OPENAI_API_KEY=$(pass show key/openai/nvimkey)
fi

# Set editor to nvim
export EDITOR=nvim
export VISUAL=nvim

#fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# StarShip
eval "$(starship init zsh)"
