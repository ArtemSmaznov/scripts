#!/usr/bin/env bash
# variables
#-------------------------------------------------------------------------------
updates_file="/var/cache/pacman/updates"

# setup
#-------------------------------------------------------------------------------
if [ ! -f "$updates_file" ]; then
    echo "Error: $updates_file is missing!"
    exit 1
fi

# execution
#===============================================================================
cat "$updates_file" |
    wc -l
