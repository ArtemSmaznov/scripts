#!/usr/bin/env bash

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_status () {
    bt_powered=$(bluetoothctl show |
                     awk '$1 == "Powered:" { print $2 }')

    case $bt_powered in
        yes) bt_status='on' ;;
        no) bt_status='off' ;;
    esac

    echo "$bt_status"
}

toggle_connection () {
    case $(get_status) in
        on) bluetoothctl power off ;;
        off) bluetoothctl power on ;;
    esac
}

set_serial_var () {
    device_name="$1"
    serial=$(bluetoothctl devices |
        awk '$3 == "'"$device_name"'" { print $2 }')

    # verify device exists
    [ -z "$serial" ] &&
        echo "error: no device '$device_name' found in" &&
        bluetoothctl devices &&
        exit 1
}

get_serial () {
    device_name="$1"
    set_serial_var "$device_name"
    echo "$serial"
}

get_devices () {
    bluetoothctl devices Connected |
        awk '{ print $3 }'
}

get_charge_state () {
    device_name="$1"
    set_serial_var "$device_name"

    # get charge level from upower
    device_path=$(upower --enumerate |
                      grep -i "${serial//:/.*}")

    charge_state=$(upower --show-info "$device_path" |
                       awk '$1 == "state:" {print $2}' |
                       sed 's/%//')

    echo "$charge_state"
}

get_charge_level () {
    device_name="$1"
    set_serial_var "$device_name"

    # get charge level from bluetoothctl
    charge_level=$(bluetoothctl info "$serial" |
                       awk '$1 == "Battery" { print $NF }' |
                       tr -d '()')

    # get charge level from upower (fallback)
    if [ -z "$charge_level" ]; then
        device_path=$(upower --enumerate |
                          grep -i "${serial//:/.*}")

        charge_level=$(upower --show-info "$device_path" |
                           awk '$1 == "percentage:" {print $2}' |
                           sed 's/%//')
    fi

    echo "$charge_level"
}

get_charge_icon () {
    device_name="$1"
    set_serial_var "$device_name"

    # get info
    icon=$(bluetoothctl info "$serial" |
               awk '$1 == "Icon:" { print $2 }')

    [ -z "$icon" ] &&
        echo "error: no icon '$icon' found in" &&
        bluetoothctl info "$serial" &&
        exit 1

    # substitute for font awesome icons
    case "$icon" in
        audio-headset) icon=headset ;;
        input-gaming)  icon=gamepad ;;
        *)             icon=question ;;
    esac

    echo "$icon"
}

# execution ********************************************************************
case $1 in
    status) get_status        ;;
    toggle) toggle_connection ;;

    get)
        case $2 in
            serial) get_serial "$3" ;;
            devices) get_devices    ;;
            charge)
                case $3 in
                    state) get_charge_state "$4" ;;
                    level) get_charge_level "$4" ;;
                    icon)  get_charge_icon  "$4" ;;
                esac ;;
        esac ;;
esac
