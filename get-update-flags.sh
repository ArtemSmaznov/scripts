#!/usr/bin/env bash
# variables --------------------------------------------------------------------
updates_file="/var/cache/pacman/updates"

# setup ------------------------------------------------------------------------
grep -q "linux-zen" "$updates_file" && flag+=
grep -q "mesa" "$updates_file" && flag+=display
grep -q "pacman" "$updates_file" && flag+=ghost
grep -q "hyprland" "$updates_file" && flag+=droplet
grep -q "wine" "$updates_file" && flag+=wine-bottle
grep -q "lutris" "$updates_file" && flag+=l

# execution ====================================================================
echo "$flag"
