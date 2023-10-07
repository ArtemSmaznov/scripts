#!/usr/bin/env bash
media_url="$1"

# variables
#-------------------------------------------------------------------------------
remote_host=shield
remote_port=5555
adb_device="$(~/.local/bin/get-ip.sh $remote_host):$remote_port"

# execution
#===============================================================================
adb -s "$adb_device" shell am start -a android.intent.action.VIEW -d "$media_url"
