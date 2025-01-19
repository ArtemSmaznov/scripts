#!/usr/bin/env bash

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function playFromBeginning() {
    mpc --quiet pause
    mpc --quiet seek 0
    mpc --quiet play
}

function skipAndRemoveFromQueue() {
    consume=$(mpc | grep -o "consume: on")

    [ ! "$consume" ] && mpc --quiet consume on
    mpc --quiet next
    [ ! "$consume" ] && mpc --quiet consume on
}

# execution ====================================================================
case $1 in
toggle) mpc --quiet toggle ;;
stop) mpc --quiet stop ;;
prev) mpc --quiet prev ;;
next) mpc --quiet next ;;
skip) skipAndRemoveFromQueue ;;
replay) playFromBeginning ;;
goto)
    seek="$2"
    mpc --quiet seek "$seek"
    ;;

repeat) mpc --quiet repeat ;;
random) mpc --quiet random ;;
single) mpc --quiet single ;;
consume) mpc --quiet consume ;;

vol-up) mpc --quiet volume +2 ;;
vol-down) mpc --quiet volume -2 ;;
esac
