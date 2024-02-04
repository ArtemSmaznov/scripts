#!/usr/bin/env bash
updates_file="/var/cache/pacman/updates"

if [ ! -f "$updates_file" ]; then
    echo "Error: $updates_file is missing!"
    exit 1
fi

cat "$updates_file" | wc -l
