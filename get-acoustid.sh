#!/usr/bin/env bash
music_file="$1"

# environment variables
#-------------------------------------------------------------------------------

# variables
#-------------------------------------------------------------------------------
acoustid_field="acoustid_id"

# functions
#-------------------------------------------------------------------------------

# setup
#-------------------------------------------------------------------------------

# execution
#===============================================================================
beet info "$music_file" |
    grep "$acoustid_field" |
    awk '{print $2}'