#!/usr/bin/env bash
prompt="$1"

# execution
#===============================================================================
echo -e "Yes\nNo" |
    rofi -dmenu -i -p "$prompt"
