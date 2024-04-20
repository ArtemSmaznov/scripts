#!/usr/bin/env bash

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_status () {
    piactl get connectionstate
}

toggle_connection () {
    case $(get_status) in
        Disconnected) piactl connect ;;
        Connected) piactl disconnect ;;
    esac
}

change_region () {
    region="$1"
    piactl set region "$region"
    piactl connect
}

# execution ********************************************************************
case $1 in
    status) get_status        ;;
    toggle) toggle_connection ;;

    set)
        case $2 in
            region) change_region "$3" ;;
        esac ;;

    get)
        case $2 in
            region)  piactl get region  ;;
            regions) piactl get regions ;;
        esac ;;


    monitor)
        case $2 in
            status) piactl monitor connectionstate ;;
            region) piactl monitor region          ;;
        esac ;;
esac
