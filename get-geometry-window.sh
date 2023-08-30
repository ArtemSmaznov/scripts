#!/usr/bin/env bash
if [[ $XDG_SESSION_TYPE == "x11" ]]; then
    # xdotool getactivewindow
    echo 0
fi

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
        hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
    fi
fi
