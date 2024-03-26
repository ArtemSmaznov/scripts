#!/usr/bin/env bash
prompt="$1"

# execution
#===============================================================================
echo -e "Yes\nNo" |
    wofi -dmenu -i -p "$prompt"
