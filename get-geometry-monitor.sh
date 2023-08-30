#!/usr/bin/env bash
if [[ $XDG_SESSION_TYPE == "x11" ]]; then
    displays=$(xrandr --listactivemonitors | grep '+' | awk '{print $4, $3}' | awk -F'[x/+* ]' '{print $1,$2"x"$4"+"$6"+"$7}')

    IFS=$'\n'
    declare -A display_mode

    for d in ${displays}; do
        name=$(echo "${d}" | awk '{print $1}')
        area="$(echo "${d}" | awk '{print $2}')"
        display_mode[${name}]="${area}"
    done

    unset IFS
fi

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
    if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
        # active_monitor=$(hyprctl -j activewindow | jq -r .monitor)
        # hyprctl -j monitors | jq -r '.[] | select(.id | contains(0))' | jq -r '"\(.x),\(.y) \(.width)x\(.height)"'
        exit
    fi
fi
exit
