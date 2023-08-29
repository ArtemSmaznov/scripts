#!/usr/bin/env bash
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
        # active_monitor=$(hyprctl -j activewindow | jq -r .monitor)
        exit
    fi
fi
exit
