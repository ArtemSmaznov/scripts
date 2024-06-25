#!/usr/bin/env bash
duration=$1

# execution ====================================================================
while (( $duration > 0 )); do
    notify-send "Starting recording in" "$duration"

    sleep 1
    dunstctl close
    ((duration--))
done
