#!/usr/bin/env bash
# variables ====================================================================
updates_file="/var/cache/pacman/updates"
[ ! -f "$updates_file" ] && echo "[ERROR] $updates_file is missing!" && exit 1

# options ----------------------------------------------------------------------

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function get_count() {
    wc -l <"$updates_file"
}

# setup ________________________________________________________________________
while getopts "jh:" opt; do
    case "$opt" in
    j) get_count ;;
    *) get_count ;;
    esac
done
shift $((OPTIND - 1))

# execution ********************************************************************
get_count
