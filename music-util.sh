#!/usr/bin/env bash

# variables ====================================================================
usage () {
    self=$(basename "$0")
    echo "Usage:
    $self fix-mp3        attempt to fix corrupted mp3 (make backup)
    $self remove-cover   removed embedded album cover art"
}

# options ----------------------------------------------------------------------
action="$1"
file="$2"

# execution ********************************************************************
case $action in
    fix-mp3)      mp3val -f "$file" ;;
    remove-cover) eyeD3 --remove-all-images "$file" ;;
    *)            usage ;;
esac
