#!/usr/bin/env bash
# variables
#-------------------------------------------------------------------------------
updates_file="/var/cache/pacman/updates"

# setup
#-------------------------------------------------------------------------------
cat "$updates_file" | grep -q "wine"      && flag+=w
cat "$updates_file" | grep -q "mesa"      && flag+=m
cat "$updates_file" | grep -q "linux-zen" && flag+=k

# execution
#===============================================================================
echo "$flag"
