#!/usr/bin/env bash
# execution ====================================================================
case $XDG_SESSION_TYPE in
wayland)
    wpctl get-volume @DEFAULT_SINK@ |
        awk '{ print $2 * 100 }'
    ;;

x11)
    amixer sget Master |
        grep "%" |
        awk -F'[][]' '{print $2}' |
        tr -d '%' |
        sort -r |
        head -1
    ;;

*) exit 1 ;;
esac
