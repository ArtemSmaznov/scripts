#!/usr/bin/env bash
# variables
#-------------------------------------------------------------------------------
headphones_name="momentum-4"

# functions
#-------------------------------------------------------------------------------
get_device_mac () {
    device_mac="$1"
    bluetoothctl devices |
        awk '$3 == "'"$device_mac"'" { print $2 }'
}

is_device_blocked () {
    device_mac="$1"
    bluetoothctl info "$device_mac" |
        awk '$1 == "Blocked:" { print $2 }'
}

toggle_action () {
    device_blocked="$1"
    [ "$device_blocked" == "yes" ] &&
        action="unblock" ||
            action="block"

    echo "$action"
}

# setup
#-------------------------------------------------------------------------------
headphones_mac=$(get_device_mac "$headphones_name")
headhones_blocked=$(is_device_blocked "$headphones_mac")

# execution
#===============================================================================
case $headhones_blocked in
    no)
        bluetoothctl block "$headphones_mac"
    ;;
    yes)
        bluetoothctl unblock "$headphones_mac"
        bluetoothctl connect "$headphones_mac"
    ;;
esac
