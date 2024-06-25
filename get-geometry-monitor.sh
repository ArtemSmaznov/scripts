#!/usr/bin/env bash
# execution ====================================================================
case $XDG_SESSION_TYPE in
    wayland)
        case $XDG_SESSION_DESKTOP in
            Hyprland)
                # active_monitor=$(hyprctl -j activewindow | jq -r .monitor)
                # hyprctl -j monitors | jq -r '.[] | select(.id | contains(0))' | jq -r '"\(.x),\(.y) \(.width)x\(.height)"'
                exit
                ;;
            *) exit 1 ;;
        esac ;;

    x11)
        displays=$(xrandr --listactivemonitors |
                       grep '+' |
                       awk '{print $4, $3}' |
                       awk -F'[x/+* ]' '{print $1,$2"x"$4"+"$6"+"$7}')

        IFS=$'\n'
        declare -A display_mode

        for d in ${displays}; do
            name=$(echo "${d}" | awk '{print $1}')
            area="$(echo "${d}" | awk '{print $2}')"
            display_mode[${name}]="${area}"
        done

        unset IFS
        ;;

    *) exit 1 ;;
esac

exit
