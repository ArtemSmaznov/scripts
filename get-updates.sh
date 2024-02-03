#!/usr/bin/env bash
[ ! "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"
updates_file="$XDG_CACHE_HOME/pacman/updates"

cat "$updates_file" | wc -l
