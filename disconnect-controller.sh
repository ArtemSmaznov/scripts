#!/usr/bin/env bash
# variables
target_device="$1"

# variables
#-------------------------------------------------------------------------------
controllers=(
    "PS4 Magma"
    "PS4 Onyx"
    "Xbox One"
)

# functions
#-------------------------------------------------------------------------------
get_device_mac () {
    device="$1"
    bluetoothctl devices | grep "$device" | awk '{print $2}' | head -1
}

# execution
#===============================================================================

for controller in "${controllers[@]}"; do
    mac_address=$(get_device_mac "$controller")
    bluetoothctl disconnect "$mac_address"
done