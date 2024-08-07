#!/usr/bin/env bash

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function get_status () {
    status=$(bluetoothctl show |
                     awk '$1 == "Powered:" { print $2 }')

    case $status in
        no)  echo 0 ;;
        yes) echo 1 ;;
    esac
}

function turn_on_connection () {
    bluetoothctl power on
}

function turn_off_connection () {
    bluetoothctl power off
}

function toggle_connection () {
    case $(get_status) in
        0) turn_on_connection  ;;
        1) turn_off_connection ;;
    esac
}

function set_serial_var () {
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
function get_serial () {
    device_name="$1"
    set_serial_var "$device_name"
    echo "$serial"
}

function get_devices () {
    type="$1"
    bluetoothctl devices "$type" |
        awk '{ print $3 }'
}

function get_charge_state () {
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

function get_charge_level () {
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

function get_charge_icon () {
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
        audio-headset) icon=headset     ;;
        input-gaming)  icon=gamepad     ;;
        audio-card)    icon=volume-high ;;
        *)             icon=question    ;;
    esac

    echo "$icon"
}

# device functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function get_device_info () {
    device_name="$1"
    field="$2"
    set_serial_var "$device_name"

    info=$(bluetoothctl info "$serial" |
                 awk '$1=="'"$field:"'" { print $2 }')

    case $info in
        # boolean
        yes) echo 1 ;;
        no)  echo 0 ;;

        # icons
        input-gaming)  echo gamepad     ;;
        audio-headset) echo headset     ;;
        audio-card)    echo volume-high ;;

        # other
        *) echo "$info" ;;
    esac
}

function toggle_device () {
    device_name="$1"
    set_serial_var "$device_name"

    case $(get_device_info "$device_name" Connected) in
        0) bluetoothctl connect "$serial"    ;;
        1) bluetoothctl disconnect "$serial" ;;
    esac
}


# execution ********************************************************************
case $1 in
    status) get_status          ;;
    toggle) toggle_connection   ;;
    off)    turn_off_connection ;;
    on)     turn_on_connection  ;;

    get)
        case $2 in
            serial) get_serial "$3" ;;
            devices)
                case $3 in
                    connected) get_devices Connected ;;
                    trusted)   get_devices Trusted   ;;
                    bonded)    get_devices Bonded    ;;
                    paired)    get_devices Paired    ;;
                    *)         get_devices Paired    ;;
                esac ;;
            charge)
                case $3 in
                    state) get_charge_state "$4" ;;
                    level) get_charge_level "$4" ;;
                    icon)  get_charge_icon  "$4" ;;
                esac ;;
        esac ;;

    device)
        case $2 in
            status)  get_device_info "$3" Connected ;;
            paired)  get_device_info "$3" Paired    ;;
            bonded)  get_device_info "$3" Bonded    ;;
            trusted) get_device_info "$3" Trusted   ;;
            blocked) get_device_info "$3" Blocked   ;;
            icon)    get_device_info "$3" Icon      ;;
            toggle)  toggle_device "$3"             ;;
        esac ;;
esac
