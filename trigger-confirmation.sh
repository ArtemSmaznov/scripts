#!/usr/bin/env bash
prompt="$1"
echo -e "Yes\nNo" | rofi -dmenu -i -p "$prompt"
