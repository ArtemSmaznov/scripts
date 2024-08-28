#!/usr/bin/env bash
# variables --------------------------------------------------------------------
[ ! "$XDG_DOCUMENTS_DIR" ] && export XDG_DOCUMENTS_DIR="$HOME/Documents"
org_note_path="$XDG_DOCUMENTS_DIR/notes/housing.org"

match_start="STRT"
match_end=":END:"
address_tag=":LOCATION:"

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
current_home=$(sed -n "/${match_start}/,/${match_end}/{p;/${match_end}/q}" "$org_note_path")

home_name=$(echo "$current_home" |
    head -1 |
    sed "s/\** $match_start //")

address=$(echo "$current_home" |
    awk '$1 == "'"$address_tag"'" { str=""; for (i=2; i<=NF; i++) str=str $i " "; print str }')

street=$(echo "$address" |
    awk -F', ' '{ print $1 }')

city=$(echo "$address" |
    awk -F', ' '{ print $(NF-2) }')

zip=$(echo "$address" |
    awk -F', ' '{ print $(NF-1) }' |
    awk '{ print $2,$3 }')

state=$(echo "$address" |
    awk -F', ' '{ print $(NF-1) }' |
    awk '{ print $1 }')

country=$(echo "$address" |
    awk -F', ' '{ print $NF }')

# execution ********************************************************************
case $1 in
name) echo "$home_name" ;;
address) echo "$address" ;;
street) echo "$street" ;;
city) echo "$city" ;;
zip) echo "$zip" ;;
state) echo "$state" ;;
country) echo "$country" ;;
*) echo "$current_home" ;;
esac
