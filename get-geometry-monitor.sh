#!/usr/bin/env bash
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
        # active_monitor=$(hyprctl -j activewindow | jq -r .monitor)
        # hyprctl -j monitors | jq -r '.[] | select(.id | contains(0))' | jq -r '"\(.x),\(.y) \(.width)x\(.height)"'
        exit
    fi
fi
exit
