#!/usr/bin/env bash
# variables
#-------------------------------------------------------------------------------
headphones_device="momentum-4"

# functions
#-------------------------------------------------------------------------------
get_device_mac () {
    device_mac="$1"
    bluetoothctl devices | grep "$device_mac" | awk '{ print $2 }'
}

is_device_blocked () {
    device_mac="$1"
    bluetoothctl info "$device_mac" | grep Blocked | awk '{ print $2 }'
}

toggle_action () {
    device_blocked="$1"
    [ "$device_blocked" == "yes" ] && action="unblock" || action="block"
    echo "$action"
}

# setup
#-------------------------------------------------------------------------------
headphones_mac=$(get_device_mac "$headphones_device")
heaphones_blocked=$(is_device_blocked "$headphones_mac")
action=$(toggle_action "$heaphones_blocked")

# execution
#===============================================================================
bluetoothctl "$action" "$headphones_mac"
