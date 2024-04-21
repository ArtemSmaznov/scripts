#!/usr/bin/env bash

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_status () {
    nmcli networking
}

toggle_connection () {
    case $(get_status) in
        enabled) nmcli networking off ;;
        disabled) nmcli networking on ;;
    esac
}

# execution ********************************************************************
case $1 in
    status) get_status        ;;
    toggle) toggle_connection ;;
esac
