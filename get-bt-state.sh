#!/usr/bin/env bash

# variables ====================================================================
bt_powered=$(bluetoothctl show |
                 awk '$1 == "Powered:" { print $2 }')

# execution ********************************************************************
case $bt_powered in
    yes) echo on ;;
    no) echo off ;;
esac
