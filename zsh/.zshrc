#Setting $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
# load ~/.local/bin to PATH
export PATH="$PATH:$HOME/.local/bin"
#load Zig to Path
export PATH="$PATH:$HOME/.local/zig-linux-x86_64-0.13.0"
#load Ghostty to Path
export PATH="$PATH:$HOME/.local/ghostty/zig-out/bin/"

# Set TERM to xterm-256color
export TERM=xterm-256color

# Set editor to nvim
export EDITOR=nvim
export VISUAL=nvim

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# StarShip
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Loads Neovim instalation
# export PATH="$PATH:/opt/nvim-linux64/bin"

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

# Vi mode
bindkey -v
# Configure keybindings in Vi normal mode
bindkey -M vicmd 'k' history-search-backward  # Use 'k' to search backward in history
bindkey -M vicmd 'j' history-search-forward   # Use 'j' to search forward in history

# Configure keybindings in Vi insert mode
bindkey -M viins '^f' autosuggest-accept  # Use 'Ctrl + f' to accept autosuggestions in Vi insert mode
bindkey -M viins '^p' history-search-backward # Use 'Ctrl + p' to search backward in history
bindkey -M viins '^n' history-search-forward  # Use 'Ctrl + n' to search forward in history
bindkey -M viins '^l' vi-cmd-mode  # Use 'Ctrl + l' to exit insert mode in Vi

bindkey '^[w' kill-region

# History
HISTSIZE=50000
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
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

#loads NVM directory to path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#Zoxide
eval "$(zoxide init zsh)"
#UV python completions
eval "$(uv generate-shell-completion zsh)"

# Validate Tools
source ~/.zsh/zsh_validations

# Load aliases
source ~/.zsh/zsh_alias

#Sesh Integration
source ~/.zsh/zsh_sesh

#load my env variables
source ~/.zsh/zsh_env

#fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

# Función para ajustar subtítulos con FFmpeg
# Uso: subsync -f 2.5 -s archivo.srt  (adelantar 2.5 segundos)
# Uso: subsync -b 1.8 -s archivo.srt  (atrasar 1.8 segundos)

subsync() {
    local direction=""
    local seconds=""
    local subtitle_file=""
    local output_file=""
    
    # Procesar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -f|--forward)
                direction="forward"
                seconds="$2"
                shift 2
                ;;
            -b|--backward)
                direction="backward"
                seconds="$2"
                shift 2
                ;;
            -s|--subtitle)
                subtitle_file="$2"
                shift 2
                ;;
            -h|--help)
                echo "Uso: subsync [OPCIÓN] -s ARCHIVO"
                echo "Ajusta la sincronización de subtítulos usando FFmpeg"
                echo ""
                echo "Opciones:"
                echo "  -f, --forward SEGUNDOS    Adelantar subtítulos N segundos"
                echo "  -b, --backward SEGUNDOS   Atrasar subtítulos N segundos"
                echo "  -s, --subtitle ARCHIVO    Archivo de subtítulos a procesar"
                echo "  -h, --help                Mostrar esta ayuda"
                echo ""
                echo "Ejemplos:"
                echo "  subsync -f 2.5 -s pelicula.srt    # Adelanta 2.5 segundos"
                echo "  subsync -b 1.8 -s serie.srt       # Atrasa 1.8 segundos"
                return 0
                ;;
            *)
                echo "Error: Opción desconocida '$1'"
                echo "Usa 'subsync -h' para ver la ayuda"
                return 1
                ;;
        esac
    done
    
    # Validar argumentos
    if [[ -z "$direction" ]]; then
        echo "Error: Debes especificar -f (forward) o -b (backward)"
        return 1
    fi
    
    if [[ -z "$seconds" ]]; then
        echo "Error: Debes especificar la cantidad de segundos"
        return 1
    fi
    
    if [[ -z "$subtitle_file" ]]; then
        echo "Error: Debes especificar el archivo de subtítulos con -s"
        return 1
    fi
    
    if [[ ! -f "$subtitle_file" ]]; then
        echo "Error: El archivo '$subtitle_file' no existe"
        return 1
    fi
    
    # Validar que seconds sea un número
    if ! [[ "$seconds" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Error: '$seconds' no es un número válido"
        return 1
    fi
    
    # Crear nombre del archivo de salida
    local base_name="${subtitle_file%.*}"
    local extension="${subtitle_file##*.}"
    
    if [[ "$direction" == "forward" ]]; then
        output_file="${base_name}_adelantado_${seconds}s.${extension}"
        offset="-${seconds}"
        action="Adelantando"
    else
        output_file="${base_name}_atrasado_${seconds}s.${extension}"
        offset="${seconds}"
        action="Atrasando"
    fi
    
    # Ejecutar FFmpeg
    echo "${action} subtítulos ${seconds} segundos..."
    echo "Archivo origen: $subtitle_file"
    echo "Archivo destino: $output_file"
    
    if ffmpeg -itsoffset "$offset" -i "$subtitle_file" -c copy "$output_file" -y 2>/dev/null; then
        echo "✅ Subtítulos ajustados exitosamente!"
        echo "📁 Archivo creado: $output_file"
    else
        echo "❌ Error al procesar los subtítulos"
        return 1
    fi
}

# Opcional: Crear un alias más corto
alias ss='subsync'


# opencode
export PATH=/home/kmiadmin/.opencode/bin:$PATH
