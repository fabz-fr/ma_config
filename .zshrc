# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="jonathan"
# ZSH_THEME="robbyrussell"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

alias Y="yazi"

plugins=(git)

source $ZSH/oh-my-zsh.sh


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
autoload -U compinit; compinit
source ~/.fzf/fzf-tab/fzf-tab.plugin.zsh

# https://github.com/junegunn/fzf/discussions/3629
modified-fzf-history-widget() {
  local selected
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases no_bash_rematch 2> /dev/null
  # appends the current shell history buffer to the HISTFILE
  builtin fc -AI $HISTFILE
  # pushes entries from the $HISTFILE onto a stack and uses this history
  builtin fc -p $HISTFILE $HISTSIZE $SAVEHIST
  selected="$(builtin fc -rl 1 |
    awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort,ctrl-z:ignore ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} --multi" $(__fzfcmd))"
  local ret=$?
	if [[ -n $selected ]]; then
    if [[ "$selected" =~ ^[[:blank:]]*[[:digit:]]+ ]]; then
	  builtin fc -pa "$HISTFILE"
	  zle vi-fetch-history -n "$MATCH"
    else # selected is a custom query, not from history
      LBUFFER="$selected"
    fi
  fi
  # Read the history from the history file into the history list
  builtin fc -R $HISTFILE
  zle reset-prompt
  return $ret
}
zle -N modified-fzf-history-widget
bindkey "^R" modified-fzf-history-widget


export FZF_CTRL_R_OPTS="$(
	cat <<'FZF_FTW'
--bind "ctrl-d:execute-silent(zsh -ic 'builtin fc -p $HISTFILE $HISTSIZE $SAVEHIST; for i in {+1}; do ignore+=( \"${(b)history[$i]}\" );done;
	HISTORY_IGNORE=\"(${(j:|:)ignore})\";builtin fc -W $HISTFILE')+reload:builtin fc -p $HISTFILE $HISTSIZE $SAVEHIST; builtin fc -rl 1 |
	awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, \"\", cmd); if (!seen[cmd]++) print $0 }'"
--bind 'enter:accept-or-print-query'
--header 'enter select · ^d remove'
--prompt ' Global History > '
FZF_FTW
)"

# 'ZDOTDIR' is a Parameter used by the shell, it refers to the location of your 
# shell startup files (see 'man zshparam')
export HISTFILE="${ZDOTDIR:-$HOME}"/.zsh_history
export HISTSIZE=12000
export SAVEHIST=10000

alias nv="nvim"
alias nvc="nvim --clean "
alias nvd="nvim -d $(mktemp) $(mktemp)"
alias v="nvim -u ~/.config/nvim/lua/config.vim"
alias vim="v"
alias vi="v"
alias c="clear"
alias bat="batcat"
alias lzg="lazygit"
alias n="nautilus"
alias task="./task.sh"
alias t="./task.sh"

sl ()
{
    grep --color=always -rnHiI --exclude='documentation/*' --exclude='*.vim' --exclude='*.out' --exclude='*.svn-base' "$1"  .
}

sf ()
{
    dir=.;
    if [[ $2 != "" ]]; then
        dir=$2;
    fi;
    find ${dir} -iname "*$1*" | grep --color=always '^\|[^/]*$'
}
sd ()
{
    dir=.;
    if [[ $2 != "" ]]; then
        dir=$2;
    fi;
    find ${dir} -type d -name "*$1*" | grep --color=always '^\|[^/]*$'
}
sp ()
{
    if [[ $2 != "" ]]; then
        awk '/${1}/' RS="\n\n" ORS="\n\n" $2
    else
        awk '/${1}/' RS="\n\n" ORS="\n\n"
    fi;
}

vv() {
  # Extraction du chemin du fichier, du numéro de ligne et de la colonne
  local file=$(echo $1 | sed -E 's/^([^:]+):.*/\1/')
  local line=$(echo $1 | sed -E 's/^[^:]+:([0-9]+).*/\1/')
  local column=$(echo $1 | sed -E 's/^[^:]+:[0-9]+:([0-9]+).*/\1/')

  # Ouvre vim au numéro de ligne et éventuellement à la colonne spécifiée
  if [[ -n $column ]]; then
    v +$line $file -c "normal ${column}|"
  else
    v +$line $file
  fi
}



swap() {
    # Vérifier qu'il y a exactement deux arguments
    if [ "$#" -ne 2 ]; then
        echo "Usage: swap_files <fichier1> <fichier2>"
        return 1
    fi

    local file1="$1"
    local file2="$2"
    local temp_file="/tmp/temp_file_$$"

    # Vérifier que les fichiers existent
    if [ ! -f "$file1" ] || [ ! -f "$file2" ]; then
        echo "Erreur : l'un des fichiers n'existe pas."
        return 1
    fi

    # Échanger les fichiers
    mv "$file1" "$temp_file" && mv "$file2" "$file1" && mv "$temp_file" "$file2"
    
    echo "Les fichiers ont été échangés : $file1 et $file2"
}

alias gs='git status'
alias glg='g lg2'

ygrep() {
    echo "$0" "$@"
    grep -s "$@" bobfiles/**/* build-dev/conf/**/* doc/**/* layers/**/*
}

