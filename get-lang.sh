#!/usr/bin/env bash
if [[ $XDG_SESSION_TYPE == "x11" ]]; then
    setxkbmap -query | awk '$1=="layout:" {print $2}'
fi

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    # if [[ $XDG_DESKTOP_SESSION == "hyprland" ]]; then
    # if [[ $XDG_SESSION_DESKTOP == "Hyprland" ]]; then
    if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
        language=$(hyprctl -j devices | jq -r '.keyboards[] | select(.name | contains("wlr")) .active_keymap')
        case "$language" in
             'English (US)') echo us;;
             'Russian') echo ru;;
             'Japanese') echo jp;;
             *) echo err;;
        esac
    fi
fi
