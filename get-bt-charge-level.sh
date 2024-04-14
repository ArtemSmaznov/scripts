#!/usr/bin/env bash
device_name="$1"

# get serial
serial=$(bluetoothctl devices |
             awk '$3 == "'"$device_name"'" { print $2 }')

# verify device exists
[ -z "$serial" ] &&
    echo "error: no device '$device_name' found in" &&
    bluetoothctl devices &&
    exit 1

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

# print result
echo "$charge_level"
