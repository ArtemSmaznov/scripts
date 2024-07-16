#!/usr/bin/env bash
# variables --------------------------------------------------------------------
target_device="$1"

# variables --------------------------------------------------------------------
controllers=(
    "kingkong3-max"
    "ps4-magma"
    "ps4-onyx"
    "xbox-one"
)

# functions --------------------------------------------------------------------
function get_device_mac () {
    device_mac="$1"
    bluetoothctl devices |
        awk '$3 == "'"$device_mac"'" { print $2 }' |
        head -1
}

# execution ====================================================================
for controller in "${controllers[@]}"; do
    mac_address=$(get_device_mac "$controller")
    bluetoothctl disconnect "$mac_address"
done
