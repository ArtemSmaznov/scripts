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

# get charge level from upower
device_path=$(upower --enumerate |
                  grep -i "${serial//:/.*}")

charge_state=$(upower --show-info "$device_path" |
                   awk '$1 == "state:" {print $2}' |
                   sed 's/%//')

# print result
echo "$charge_state"
