#!/usr/bin/env bash
device_name="$1"

# get serial ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
serial=$(bluetoothctl devices |
             awk '$3 == "'"$device_name"'" { print $2 }')

[ -z "$serial" ] &&
    echo "error: no device '$device_name' found in" &&
    bluetoothctl devices &&
    exit 1

# get info ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
icon=$(bluetoothctl info "$serial" |
           awk '$1 == "Icon:" { print $2 }')

[ -z "$icon" ] &&
    echo "error: no icon '$icon' found in" &&
    bluetoothctl info "$serial" &&
    exit 1

# substitute for font awesome icons ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
case "$icon" in
    audio-headset) icon=headset ;;
    input-gaming)  icon=gamepad ;;
    *)             icon=question ;;
esac

# execution ********************************************************************
echo "$icon"
