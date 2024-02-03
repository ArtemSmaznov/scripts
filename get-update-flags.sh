#!/usr/bin/env bash
[ ! "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"
updates_file="$XDG_CACHE_HOME/pacman/updates"

cat "$updates_file" | grep -q "wine"      && flag+=w
cat "$updates_file" | grep -q "mesa"      && flag+=m
cat "$updates_file" | grep -q "linux-zen" && flag+=k

echo "$flag"
