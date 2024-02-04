#!/usr/bin/env bash
updates_file="/var/cache/pacman/updates"

cat "$updates_file" | grep -q "wine"      && flag+=w
cat "$updates_file" | grep -q "mesa"      && flag+=m
cat "$updates_file" | grep -q "linux-zen" && flag+=k

echo "$flag"
