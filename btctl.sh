#!/usr/bin/env bash

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_status () {
    status=$(bluetoothctl show |
                     awk '$1 == "Powered:" { print $2 }')

    case $status in
        no)  echo 0 ;;
        yes) echo 1 ;;
    esac
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

# get functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

# device functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_device_status () {
    device_name="$1"
    set_serial_var "$device_name"

    status=$(bluetoothctl info "$serial" |
                 awk '$1=="Connected:" { print $2 }')

    case $status in
        yes) echo 1 ;;
        no)  echo 0 ;;
    esac
}

get_blocked_status () {
    device_name="$1"
    set_serial_var "$device_name"

    status=$(bluetoothctl info "$serial" |
                 awk '$1=="Blocked:" { print $2 }')

    case $status in
        yes) echo 1 ;;
        no)  echo 0 ;;
    esac
}

toggle_device () {
    device_name="$1"
    set_serial_var "$device_name"

    case $(get_device_status "$device_name") in
        0) bluetoothctl connect "$serial"    ;;
        1) bluetoothctl disconnect "$serial" ;;
    esac
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

    device)
        case $2 in
            status) get_device_status "$3" ;;
            blocked) get_blocked_status "$3" ;;
            toggle) toggle_device "$3" ;;
        esac ;;
esac
