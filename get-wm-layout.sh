#!/usr/bin/env bash
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    if [[ $XDG_SESSION_DESKTOP == "Hyprland" ]]; then
        hyprctl getoption -j general:layout | jq -r .str
    fi
fi
