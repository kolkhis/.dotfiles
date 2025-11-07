# shellcheck shell=bash
# shellcheck disable=SC2059,SC1091


# Auto-flags
alias ls='ls --color=auto --classify'
alias ll='ls --color=auto --classify --almost-all -l --human-readable' 
alias l='ls -CFAlh'
alias la='ls -A'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias cal="ncal -b"
alias tree="tree -a"
alias ip="ip -color"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias gits="git status"
alias gs="git status -s"

alias tmux='tmux -f "${XDG_CONFIG_HOME}/tmux/.tmux.conf"'
alias "??"="gpt"
alias "?"="ddg"
alias py="python3"
alias python="python3"
alias pythong="python3"
alias vi="\$(which nvim)";
alias vim="nvim"
alias lv="vim -c \"normal '0\""
alias vl="vi -c \"normal '0\""
alias clsa='printf "\e[H\e[2J"'
alias cls='printf "\e[H\e[2J"'
alias c='clear'
alias path='printf "${PATH//:/\\n}\n"'
alias f='fzf'

# Navigation
alias dots="cd ~/.dotfiles/"
alias lu="cd ~/Repos/github.com/kolkhis/lab-utils"
alias nv="cd ~/.dotfiles/nvim/.config/nvim/"
alias v="cd ~/.dotfiles/vim"
alias rp="cd ~/Repos/github.com/kolkhis/"
alias s="cd ~/.dotfiles/scripts/.local/bin/"
alias n="cd ~/notes/"
alias db="cd ~/Repos/github.com/kolkhis/discord_bot/"
alias tb="cd ~/Repos/github.com/kolkhis/twitch_chat_bot/"
alias bsg='cd ~/Repos/github.com/kolkhis/lab-utils/prolug/bash-sg/'

case "$OSTYPE" in
    (msys)
        alias nv="cd ~/AppData/Local/nvim";
        ;;
    (*)
        alias nv="cd ~/.dotfiles/nvim/.config/nvim/";
        ;;
esac

# Using vim/neovim as `less`
export VRT="/usr/share/vim/vim82"
alias vless="\${VRT}/macros/less.sh"
export NVRT="/usr/share/nvim/runtime/"
alias nvl="\${NVRT}/macros/less.sh"

