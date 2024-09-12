#!/usr/bin/env bash
# execution ====================================================================
case $XDG_SESSION_TYPE in
wayland)
    wpctl set-mute @DEFAULT_SINK@ toggle
    ;;

x11)
    amixer -q sset Master toggle
    ;;

*) exit 1 ;;
esac
