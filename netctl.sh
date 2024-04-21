#!/usr/bin/env bash

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_status () {
    con_type="$1"
    status=$(nmcli --fields 'type,state' device status |
                 awk '$1 == "'"$con_type"'" { print $2 }' |
                 grep -v dev)

    case $status in
        disconnected) echo 0 ;;
        connected)    echo 1 ;;
    esac
}

toggle_connection () {
    con_type="$1"
    device=$(get_device "$con_type")
    case $(get_status "$con_type") in
        0) nmcli device connect "$device"    ;;
        1) nmcli device disconnect "$device" ;;
    esac >/dev/null
}

# get functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_device () {
    con_type="$1"
    nmcli --fields 'type,device' device status |
        awk '$1 == "'"$con_type"'" { print $2 }' |
        grep -v dev
}

get_connection () {
    con_type="$1"
    nmcli --fields 'type,connection' device status |
        awk '$1 == "'"$con_type"'" { str=""; for (i=2; i<=NF; i++) str=str $i " "; print str }' |
        grep -v dev
}

# execution ********************************************************************
case $1 in
    status) get_status "$2"        ;;
    toggle) toggle_connection "$2" ;;

    get)
        case $2 in
            device) get_device "$3" ;;
            connection) get_connection "$3" ;;
        esac
        ;;
esac
