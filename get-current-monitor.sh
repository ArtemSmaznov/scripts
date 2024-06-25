#!/usr/bin/env bash
[ "$1" ] && param=$1 || param=name

# environment variables --------------------------------------------------------
[ ! "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"

# variables --------------------------------------------------------------------

# functions --------------------------------------------------------------------

# setup ------------------------------------------------------------------------

# execution ====================================================================
case $XDG_SESSION_TYPE in
    wayland)
        case $XDG_SESSION_DESKTOP in
            Hyprland) "$XDG_CONFIG_HOME"/hypr/scripts/get-current-monitor.sh "$param" ;;
            *) exit 1 ;;
        esac ;;

    *) exit 1 ;;
esac
