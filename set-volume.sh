#!/usr/bin/env bash
#
# Usage: set-volume.sh [+-] [%step]
# Examples:
# - set-volume.sh + 2
# - set-volume.sh - 1

direction=$1
step=$2

# execution ====================================================================
case $XDG_SESSION_TYPE in
wayland)
    wpctl set-volume @DEFAULT_SINK@ "${step}%${direction}"
    wpctl set-mute @DEFAULT_SINK@ 0
    ;;

x11)
    amixer -q sset Master "${step}%${direction}" unmute
    ;;

*) exit 1 ;;
esac
