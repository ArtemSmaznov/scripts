#!/usr/bin/env bash
field="$1"
music_file="$2"

# execution
#===============================================================================
beet list "path:$music_file" -f "\$$field"
