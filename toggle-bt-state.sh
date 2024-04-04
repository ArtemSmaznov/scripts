#!/usr/bin/env bash

# variables ====================================================================
bt_state=$(~/.local/bin/get-bt-state.sh)

# setup ________________________________________________________________________
case $bt_state in
    on) action="off" ;;
    off) action="on" ;;
esac

# execution ********************************************************************
bluetoothctl power "$action"
