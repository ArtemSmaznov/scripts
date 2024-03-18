#!/usr/bin/env bash
# execution
#===============================================================================
case $XDG_SESSION_TYPE in
    wayland)
        case $XDG_SESSION_DESKTOP in
            Hyprland)
                language=$(hyprctl -j devices |
                               jq -r '.keyboards[] | select(.name | contains("wlr")) .active_keymap')
                case "$language" in
                    'English (US)') echo us;;
                    'Russian') echo ru;;
                    'Japanese') echo jp;;
                    *) echo err;;
                esac
                ;;
            *) exit 1 ;;
        esac ;;

    x11)
        setxkbmap -query |
            awk '$1=="layout:" {print $2}'
        ;;

    *) exit 1 ;;
esac
