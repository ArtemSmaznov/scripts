#!/usr/bin/env bash
metric=$1
device=$2

# execution
#===============================================================================
# upower -i "/org/freedesktop/UPower/devices/battery_ps_controller_battery_a0oabo51o62o65o1d"
upower -i "/org/freedesktop/UPower/devices/$device" |
    awk '$1 == "'"$metric"':" {print $2}' |
    sed 's/%//'
