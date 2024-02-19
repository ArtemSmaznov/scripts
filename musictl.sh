#!/usr/bin/env bash
seek="$2"

# execution
#===============================================================================
case $1 in
    toggle)    mpc toggle       ;;
    stop)      mpc stop         ;;
    prev)      mpc prev         ;;
    next)      mpc next         ;;
    goto)      mpc seek "$seek" ;;

    repeat)    mpc repeat       ;;
    random)    mpc random       ;;
    single)    mpc single       ;;
    consume)   mpc consume      ;;

    vol-up)    mpc volume +2    ;;
    vol-down)  mpc volume -2    ;;
esac
