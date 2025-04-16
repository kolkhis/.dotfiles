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
alias vi="\$(which vim)";
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
alias aoc="cd ~/Repos/github.com/kolkhis/aoc-2023/"
alias nv="cd ~/.dotfiles/nvim/.config/nvim/"
alias v="cd ~/.dotfiles/vim"
alias boost="cd ~/notes/skilstak/" 
alias rp="cd ~/Repos/github.com/kolkhis/"
alias s="cd ~/.dotfiles/scripts/.local/bin/"
alias n="cd ~/notes/"
alias ta="cd ~/Repos/github.com/kolkhis/taggart"
alias tw="cd ~/Repos/github.com/kolkhis/twitch_chat_bot/"
alias gl="cd ~/Repos/github.com/kolkhis/go-fundamentals/"
alias db="cd ~/Repos/github.com/kolkhis/discord_bot/"
alias tb="cd ~/Repos/github.com/kolkhis/twitch_chat_bot/"
alias i3c="vim ~/.dotfiles/i3/.config/i3/config"

case $(hostname) in
    ("D01")
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

