#!/bin/bash

getcolor() {
    if [[ -z "$1" || "$1" -gt 255 || "$1" -lt 0 ]]; then
        printf "You need to provide a number 0-255\n"
        return
    fi
    black_text=$'\e[38;5;232m'
    white_text=$'\e[38;5;255m'
    black_bg=$'\e[48;5;232m'
    white_bg=$'\e[48;5;255m'
    r=$'\e[0m'
    printf "\e[38;5;%smThis is the foreground 255-color repr of $1%s\n" "$1" "$r"
    printf "%s\e[38;5;%smThis is the foreground 255-color repr of $1%s\n" "$black_bg" "$1" "$r"
    printf "%s\e[38;5;%smThis is the foreground 255-color repr of $1%s\n" "$white_bg" "$1" "$r"
    printf "%s\e[48;5;%smThis is the background 255-color repr of $1%s\n" "$black_text" "$1" "$r"
    printf "%s\e[48;5;%smThis is the background 255-color repr of $1%s\n" "$white_text" "$1" "$r"
}

RESET="\[\e[0m\]"

check_venv() {
    [[ -n "$VIRTUAL_ENV" ]] && printf "(%s) " "${VIRTUAL_ENV##*/}"
}

get_git_branch() {
    # git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    git branch -l 2>/dev/null | perl -ne 'print " ($1)" if m/^\*\s(.*)/'
}

shopts() {
    PAGER='less "+/^ *The list of shopt"' man bash
}

standardcolors() {
    for i in {0..7}; do
        c=$'\e[3'${i}'m'
        printf "%sColor Code: %s\n" "$c" "$i"
    done
}

soundbar() {
    if pacmd list-sinks | grep "alsa_output.pci-0000_29_00.4.iec958-stereo" > /dev/null 2>&1; then
        if ! pacmd set-default-sink alsa_output.pci-0000_29_00.4.iec958-stereo; then
            printf "Couldn't set the audio output to the soundbar!\n"
        else
            printf "Successfully redirected audio output to the soundbar.\n"
        fi
    else
        printf "Soundbar not found!\nTry one of these:\n%s" "$(pacmd list-sinks | grep "name:")";
    fi;
}

pwd_shortened() {
    pwd | sed -E "s;^$HOME;~;" 2>/dev/null | sed -E 's;.*/(.*/.*$);\1;' 2>/dev/null
}

read_hide() {
    while [[ -n "$1" ]]; do
        case $1 in
            -p | --prompt)
                shift
                PROMPT="$1"
                shift
                ;;
            -h | --hide | --hide-all)
                HIDE_ALL=true
                shift
                ;;
            *)
                PROMPT="$1"
                shift
                ;;
        esac
    done
    [[ -z "$PROMPT" ]] && PROMPT="Input: "
    printf "%s" "$PROMPT"
    unset INPUT
    if [[ -z "$HIDE_ALL" ]]; then
        while IFS= read -r -s -n1 KEYPRESS; do
            # KEYPRESS is empty when the user hits enter
            if [[ -z $KEYPRESS ]]; then
                printf "\n"
                break
            elif [[ $KEYPRESS == $'\x7f' ]] || [[ $KEYPRESS == $'\x08' ]]; then
                if [[ -n $INPUT ]]; then
                    printf "\b \b"
                    INPUT=${INPUT:0:$((${#INPUT} - 1))}
                fi
            else
                printf "*"
                INPUT+=$KEYPRESS
            fi
        done
        printf "%s" "$INPUT" 2>/dev/null
    else
        stty_original=$(stty -g)
        stty -echo
        read -r INPUT
        stty "$stty_original"
        printf "%s" "$INPUT" 2>/dev/null
    fi
}

m() {
    if [[ -z "$1" ]]; then
        nvim -c "tab Man bash" -c 'normal gt' -c "wincmd q"
    elif [[ -n "$1" ]]; then
        nvim -c "tab Man $1" -c "normal gt" -c "wincmd q"
    fi
}
complete -A command m

tmux-breakw(){
    # break-pane ‘#{session_name}:#{window_index}.#{pane_index}’
    local src_window
    local window_name
    local new_session_name

    src_window=$(tmux display-message -p '#{session_name}:#{window_index}')
    window_name=$(tmux display-message -p '#{window_name}')

    [[ -n $1 ]] && new_session_name=$1
    printf "Creating new session: %s\n" "${new_session_name:=${window_name// /-}}"

    tmux break-pane -d \
        -s "$src_window" \
        -n "$window_name" \
        -t "${window_name// /-}"
}

catconf() {
    # Cat a config file ignoring comments, INI-style headers, and empty lines
    [[ -f "$1" ]] || { printf "No file found with the name: %s\n" "$1" && return 1; }
    grep -Po '^\s*(?![#;]|\[").+$' "$1"
}

