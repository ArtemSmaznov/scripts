#!/usr/bin/env bash
# variables
#-------------------------------------------------------------------------------
updates_file="/var/cache/pacman/updates"

# setup
#-------------------------------------------------------------------------------
grep -q "wine"      "$updates_file" && flag+=wine-bottle
grep -q "mesa"      "$updates_file" && flag+=display
grep -q "linux-zen" "$updates_file" && flag+=
grep -q "hyprland"  "$updates_file" && flag+=droplet

# execution
#===============================================================================
echo "$flag"
