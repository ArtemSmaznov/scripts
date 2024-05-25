#!/usr/bin/env bash
# setup
#-------------------------------------------------------------------------------
case $XDG_SESSION_TYPE in
    wayland)
        case $XDG_SESSION_DESKTOP in
            Hyprland)
                language=$(hyprctl -j devices |
                               jq -r '.keyboards[] | select(.main) .active_keymap')
                case "$language" in
                    'English (US)') lang=us ;;
                    'Russian') lang=ru ;;
                    'Japanese') lang=jp ;;
                    *) echo "error: could not identify active keymap" && exit 1 ;;
                esac
                ;;
            *) exit 1 ;;
        esac ;;

    x11)
        lang=$(setxkbmap -query | awk '$1=="layout:" {print $2}')
        ;;

    *) exit 1 ;;
esac

# execution
#===============================================================================
echo "$lang"
