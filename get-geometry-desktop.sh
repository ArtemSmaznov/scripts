#!/usr/bin/env bash
# execution ====================================================================
case $XDG_SESSION_TYPE in
    wayland)
        case $XDG_SESSION_DESKTOP in
            Hyprland) exit ;;
            *) exit 1 ;;
        esac ;;

    *) exit 1 ;;
esac

exit
