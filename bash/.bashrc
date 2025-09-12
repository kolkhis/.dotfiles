# shellcheck disable=SC2059,SC1091,SC1090

# /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples

# If not running interactively, don't do anything
case "$-" in
    *i*) ;;
    *) return ;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "${debian_chroot:-}" ]] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors && -r ~/.dircolors ]]; then
    eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

[[ -f ~/.bash_functions ]] && \. ~/.bash_functions
[[ -f ~/.bash_aliases ]] && \. ~/.bash_aliases

# Enable programmable bash completion in interactive shells
if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        \. /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        \. /etc/bash_completion
    fi
fi

################################## Env ##################################
# nvm
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"

# crablang
[[ -s "$HOME/.cargo/env" ]] && \. "$HOME/.cargo/env"

export FZF_DEFAULT_COMMAND='find . -type f ! -path "*/.git/*"'
export FZF_DEFAULT_OPTS="\
--tabstop=4 \
--preview 'cat {}' \
--preview-window 'right,50%,border-rounded' \
--bind '?:preview:file {}' \
--bind 'change:first' \
--bind 'enter:execute(nvim {})' \
--bind 'ctrl-d:preview-page-down' \
--bind 'ctrl-l:forward-char' \
--bind 'ctrl-h:backward-char' \
--bind 'ctrl-f:preview-down' \
--bind 'ctrl-b:preview-up' \
--bind 'ctrl-u:clear-query' \
--bind 'ctrl-w:backward-kill-word' \
--bind 'ctrl-\\:change-preview-window(bottom,70%,border-rounded|hidden|)' \
"

# Colors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GREP_COLORS=':ms=01;31:mc=01;31:sl=38;5;248:cx=38;5;244:fn=38;5;68:ln=38;5;81:bn=32:se=36'
[[ -s "$HOME/.dircolors" ]] && eval "$(dircolors -b ~/.dircolors)"

# -R is needed for the escape sequences
export LESS="-FXR"

# cdpath
declare -x CDPATH="."
CDPATH="${CDPATH}:~"
CDPATH="${CDPATH}:~/Repos/github.com/kolkhis"
CDPATH="${CDPATH}:~/Repos/github.com/ProfessionalLinuxUsersGroup"
CDPATH="${CDPATH}:~/notes"
CDPATH="${CDPATH}:~/notes/linux"
# export CDPATH='.:~:~/notes:~/Repos/github.com/kolkhis:~/Repos/github.com/ProfessionalLinuxUsersGroup:~/notes/linux:~/.dotfiles'

export SCREENRC="$HOME/.config/.screenrc"

################################## PS1 ##################################

# Python: Prevent default "(venv)" text
export VIRTUAL_ENV_DISABLE_PROMPT=1

# prompt colors wrapped \[...\] so terminal can determine proper line length
YELLOW="\[\e[38;5;214m\]"
BURNT_ORANGE="\[\e[38;5;130m\]"
DARK_YELLOW="\[\e[38;5;58m\]"
GREY="\[\e[38;5;241m\]"
MUTED_BLUEGREEN="\[\e[38;5;30m\]"
RED_256="\[\e[38;5;160m\]"
RESET="\[\e[0m\]"
LIGHT_PURPLE="\[\e[38;5;99m\]"
SOFT_PINK="\[\e[38;5;212m\]"
DARK_RED="\[\e[38;5;88m\]"
SEP_COLOR=${DARK_RED}
FIRST_SEP="┎"  # ┎┏┍ ┏ ┒ ┒┎ ┏ ┍
SECOND_SEP="┖" # ┖┗┕ ┖ ┚ ┨┠ ┣ ┝ ┫┠ ┚┖ ┗ ┕

case $USER in
    root)
        NAME_COLOR=${RED_256}
        HOST_COLOR=${BURNT_ORANGE}
        PATH_COLOR=${LIGHT_PURPLE}
        VENV_COLOR=${SOFT_PINK}
        ;;
    *)
        NAME_COLOR=${DARK_YELLOW}
        HOST_COLOR=${BURNT_ORANGE}
        PATH_COLOR=${MUTED_BLUEGREEN}
        VENV_COLOR=${YELLOW}
        ;;
esac

set_prompt() {
    if grep 'cyg' <<< "$ORIGINAL_PATH" > /dev/null 2>&1; then
        SEP_COLOR='\[\e[38;5;95m\]'
        NAME_COLOR='\[\e[38;5;61m\]'
        PATH_COLOR='\[\e[38;5;24m\]'
    else
        SEP_COLOR='\[\e[38;5;88m\]'
    fi

    export PROMPT_DIRTRIM=2
    if type get_git_branch check_venv > /dev/null 2>&1; then
        PS1="${SEP_COLOR}${FIRST_SEP} " 
        PS1="${PS1}${NAME_COLOR}\u"
        PS1="${PS1}${GREY}@"
        PS1="${PS1}${HOST_COLOR}\h"
        PS1="${PS1}${GREY}:"
        PS1="${PS1}${PATH_COLOR}\w"
        # PS1="${PS1}""\$(pwd_shortened)"
        PS1="${PS1}${RED_256}\$(get_git_branch)"
        PS1="${PS1}\n${SEP_COLOR}${SECOND_SEP} "
        PS1="${PS1}${VENV_COLOR}\$(check_venv)"
        PS1="${PS1}${GREY}\\$ ${RESET}"
    else
        PS1="${SEP_COLOR}${FIRST_SEP} " 
        PS1="$PS1""${NAME_COLOR}\u"
        PS1="$PS1""${GREY}@"
        PS1="$PS1""${HOST_COLOR}\h"
        PS1="$PS1""${GREY}:"
        PS1="$PS1""${PATH_COLOR}\w"
        PS1="$PS1""${RED_256}"
        PS1="$PS1""\n${SEP_COLOR}${SECOND_SEP} "
        PS1="$PS1""${GREY}\\$ ${RESET}"
    fi
}

# Different prompt for git bash
# Set XDG_CONFIG_HOME/DATA on Linux if it's unset, add nvim to path if on windows
case $OSTYPE in
    *msys*)
        grep -qi -E 'neovim' <<< "$PATH" > /dev/null 2>&1 ||
            export PATH="$PATH:/c/Program Files/Neovim/bin"
        { [[ -f /etc/profile.d/git-prompt.sh ]] && \. /etc/profile.d/git-prompt.sh; } || set_prompt
        ;;
    *linux*)
        [[ -z "$XDG_CONFIG_HOME" ]] && export XDG_CONFIG_HOME="${HOME}/.config"
        [[ -z "$XDG_DATA_HOME" ]] && export XDG_DATA_HOME="${HOME}/.local/share"
        set_prompt
        ;;
    *)
        set_prompt
        ;;
esac
export PS1
export PS2="${GREY}~>${RESET} "


################################## Shell Options ##################################
# omit duplicate lines or lines starting with space
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Recursively expand directories with "**"
shopt -s globstar
shopt -s dotglob
shopt -s nocaseglob

# god mode
set -o vi

################################## System Variables ##################################
# export TERM=xterm-256color
export TZ="America/New_York"
export NOTES_HOME="/home/kolkhis/notes"
export LC_ALL=C.UTF-8
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export PATH=~/bin:$PATH
export COLUMNS=120 LINES=30
GPG_TTY=$(tty)
export GPG_TTY

export PATH=$PATH:/usr/local/go/bin
export CGO_ENABLED=0
export GO111MODULE=on

# Make sure cursor is a block
printf "\x1b[\x30 q"

