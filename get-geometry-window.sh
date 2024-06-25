#!/usr/bin/env bash
# execution ====================================================================
case $XDG_SESSION_TYPE in
    wayland)
        case $XDG_SESSION_DESKTOP in
            Hyprland)
                hyprctl -j activewindow |
                    jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
                ;;
            *) exit 1 ;;
        esac ;;

    x11)
        # xdotool getactivewindow
        echo 0
        ;;

    *) exit 1 ;;
esac
