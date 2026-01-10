# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# # # # # # # # # # # # # # # # #
# ┏┳┓╻ ╻   ┏━╸┏━┓┏┓╻┏━╸╻┏━╸┏━┓  #
# ┃┃┃┗┳┛   ┃  ┃ ┃┃┗┫┣╸ ┃┃╺┓┗━┓  #
# ╹ ╹ ╹    ┗━╸┗━┛╹ ╹╹  ╹┗━┛┗━┛  #
# # # # # # # # # # # # # # # # #
setopt nocorrect

export BROWSER="firefox"
export TERMINAL="kitty"
export DATE=$(date "+%A, %B %e  %_I:%M%P")
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 80% --preview='bat -p --color=always {}'"
export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview" # separate opts for history widget
export MANPAGER="less -R --use-color -Dd+r -Du+b" # colored man pages

export PATH="$PATH:$HOME/.scripts/cmd"

# Smart Case Search For Bat etc..
export LESS="-I"

unsetopt beep
setopt autocd extendedglob nomatch

# Load pywal colors
[ -f ~/.cache/wal/colors.sh ] && source ~/.cache/wal/colors.sh
#
# Load wal colors for eza
[ -f ~/.cache/wal/eza-colors ] && source ~/.cache/wal/eza-colors

# export LS_COLORS
export LS_COLORS="{{ ls_colors }}"


## History
HISTFILE=~/.cache/zsh/history
HISTSIZE=1000
SAVEHIST=1000
HISTCONTROL=ignoreboth # consecutive duplicates & commands starting with space are not saved

# better real-time history between shells:
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

# Cleaner history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE # Don't record an entry starting with a space.

# Completion:
zstyle ':completion:*' menu select # show & select completions
# zstyle ':completion:*' special-dirs false # to show . and ..
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu
# zstyle ':completion:*' file-list true # more detailed list
# zstyle ':completion:*' squeeze-slashes false # explicit disable to allow /*/ expansion

setopt interactive_comments # allow comments in interactive shells
setopt globdots # Include hidden files.
setopt no_case_glob no_case_match # case insensitive
setopt extended_glob # support more glob searches

zmodload zsh/complist # gives me menuselect...and probably other stuff IDK

# ctrl p/n to navigate previous commands
bindkey '^p' up-line-or-history
bindkey '^n' down-line-or-history

# fzf setup
source <(fzf --zsh) # allow for fzf history widget
bindkey '^R' fzf-history-widget


# # # # # # # # # # # # # # # # # # # #
# ┏┳┓┏━┓╻┏ ┏━╸   ╻╺┳╸   ┏━╸┏━┓   ╻ ╻╻ #
# ┃┃┃┣━┫┣┻┓┣╸    ┃ ┃    ┃╺┓┃ ┃   ┃┏┛┃ #
# ╹ ╹╹ ╹╹ ╹┗━╸   ╹ ╹    ┗━┛┗━┛   ┗┛ ╹ #
# # # # # # # # # # # # # # # # # # # #

bindkey -v
export KEYTIMEOUT=1
export EDITOR=vim
export VISUAL=vim


# take selection to vim buffer:
autoload -Uz edit-command-line
zle -N edit-command-line
# bindkey '^X^E' edit-command-line   # Ctrl+X Ctrl+E
bindkey -M vicmd Y edit-command-line

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# INSERT-mode bindings
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^N' down-history
bindkey -M viins '^P' up-history

bindkey -M viins '^O' kill-line
bindkey -M viins '^k' backward-kill-word
bindkey -M viins '^Y' copy-region-as-kill


# # # # # # # # # # # # # # # # # # #
# ┏━┓╻ ╻┏━╸╻ ╻   ┏┓ ╻  ┏━┓┏━┓╺┳╸┏━┓ #
# ┗━┓┃ ┃┃  ┣━┫   ┣┻┓┃  ┃ ┃┣━┫ ┃ ┗━┓ #
# ┗━┛┗━┛┗━╸╹ ╹   ┗━┛┗━╸┗━┛╹ ╹ ╹ ┗━┛ #
# # # # # # # # # # # # # # # # # # #

[ -f "$HOME/.config/shell/aliases" ] && source   "$HOME/.config/shell/aliases"
[ -f "$HOME/.config/shell/dirs" ] && source      "$HOME/.config/shell/dirs"
[ -f "$HOME/.config/shell/files" ] && source     "$HOME/.config/shell/files"
# Prevent alias/function collisions
unalias c 2>/dev/null
[ -f "$HOME/.config/shell/functions" ] && source "$HOME/.config/shell/functions"
[ -f "$HOME/.config/shell/arch" ] && source      "$HOME/.config/shell/arch"
unalias gbd 2>/dev/null
unalias gcm 2>/dev/null
[ -f "$HOME/.config/shell/gitcmds" ] && source   "$HOME/.config/shell/gitcmds"
[ -f "$HOME/.config/shell/funzies" ] && source   "$HOME/.config/shell/funzies"

