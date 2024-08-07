#!/usr/bin/env bash

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function get_status () {
    con_type="$1"
    status=$(nmcli --fields 'type,state' device status |
                 awk '$1 == "'"$con_type"'" { print $2 }' |
                 grep -v dev)

    case $status in
        unavailable)  echo 0 ;;
        disconnected) echo 0 ;;
        connected)    echo 1 ;;
    esac
}

function toggle_connection () {
    con_type="$1"

    if [ "$con_type" == 'ethernet' ]; then
        device=$(get_device "$con_type")
        case $(get_status "$con_type") in
            0) nmcli device connect "$device"    ;;
            1) nmcli device disconnect "$device" ;;
        esac >/dev/null
    fi

    if [ "$con_type" == 'wifi' ]; then
        case $(get_status "$con_type") in
            0) nmcli radio wifi on  ;;
            1) nmcli radio wifi off ;;
        esac >/dev/null
    fi
}

# get functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function get_device () {
    con_type="$1"
    nmcli --fields 'type,device' device status |
        awk '$1 == "'"$con_type"'" { print $2 }' |
        grep -v dev
}

function get_connection () {
    con_type="$1"
    nmcli --fields 'type,connection' device status |
        awk '$1 == "'"$con_type"'" { str=""; for (i=2; i<=NF; i++) str=str $i " "; print str }' |
        grep -v dev
}

# monitor functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function monitor_status () {
    con_type="$1"
    device=$(get_device "$con_type")
    get_status "$con_type"

    nmcli device monitor "$device" |
        while read -r line; do
            case $(echo "$line" | awk '{ print $2 }') in
                deactivating) echo -0.5    ;;
                unavailable)  echo 0       ;;
                disconnected) echo 0       ;;
                connecting)   echo 0.5     ;;
                connected)    echo 1       ;;
            esac
        done
}

function monitor_connection () {
    con_type="$1"
    device=$(get_device "$con_type")
    get_connection "$con_type"

    nmcli device monitor "$device" |
        while read -r line; do
            [[ "$line" =~ "using connection" ]] &&
                echo "${line/* \'/}" |
                    tr -d "'"
        done
}

# execution ********************************************************************
case $1 in
    status) get_status "$2"        ;;
    toggle) toggle_connection "$2" ;;

    get)
        case $2 in
            device)     get_device "$3"     ;;
            connection) get_connection "$3" ;;

            wifi)
                case $3 in
                    pass) nmcli device wifi show-password ;;
                esac ;;

        esac ;;

    monitor)
        case $2 in
            status)     monitor_status "$3"     ;;
            connection) monitor_connection "$3" ;;
        esac ;;
esac
