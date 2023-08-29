#!/usr/bin/env bash
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
        exit
    fi
fi
exit
