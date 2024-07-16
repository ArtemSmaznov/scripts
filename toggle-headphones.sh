#!/usr/bin/env bash
# variables --------------------------------------------------------------------
device_name="momentum-4"

# functions --------------------------------------------------------------------
function get_device_mac () {
    device_mac="$1"
    bluetoothctl devices |
        awk '$3 == "'"$device_mac"'" { print $2 }'
}

function is_device_blocked () {
    device_mac="$1"
    bluetoothctl info "$device_mac" |
        awk '$1 == "Blocked:" { print $2 }'
}

function toggle_action () {
    device_blocked="$1"
    [ "$device_blocked" == "yes" ] &&
        action="unblock" ||
            action="block"

    echo "$action"
}

# setup ------------------------------------------------------------------------
device_mac=$(get_device_mac "$device_name")
device_blocked=$(is_device_blocked "$device_mac")

# execution ====================================================================
case $device_blocked in
    no)
        bluetoothctl block "$device_mac"
    ;;
    yes)
        bluetoothctl unblock "$device_mac"
        bluetoothctl connect "$device_mac"
    ;;
esac
