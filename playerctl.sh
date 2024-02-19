#!/usr/bin/env bash
# player="$2"

# execution
#===============================================================================
case $1 in
    toggle)    playerctl play-pause   ;;
    stop)      playerctl stop         ;;
    prev)      playerctl previous     ;;
    next)      playerctl next         ;;

    vol-up)    playerctl volume 0.02+ ;;
    vol-down)  playerctl volume 0.02- ;;
esac
