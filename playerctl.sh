#!/usr/bin/env bash
# variables ====================================================================
# player="$2"
volume_step=0.01

# execution ====================================================================
case $1 in
toggle) playerctl play-pause ;;
stop) playerctl stop ;;
prev) playerctl previous ;;
next) playerctl next ;;

vol-up) playerctl volume ${volume_step}+ ;;
vol-down) playerctl volume ${volume_step}- ;;
esac
