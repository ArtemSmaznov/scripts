#!/usr/bin/env bash
seek="$2"

case $1 in
    toggle)    playerctl play-pause   ;;
    stop)      playerctl stop         ;;
    prev)      playerctl previous     ;;
    next)      playerctl next         ;;
    goto)      mpc seek "$seek"       ;;

    repeat)    mpc repeat             ;;
    random)    mpc random             ;;
    single)    mpc single             ;;
    consume)   mpc consume            ;;

    vol-up)    playerctl volume 0.02+ ;;
    vol-down)  playerctl volume 0.02- ;;
esac

~/.local/bin/update-music.sh
