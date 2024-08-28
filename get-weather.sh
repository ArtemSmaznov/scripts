#!/usr/bin/env bash
# variables --------------------------------------------------------------------
cache_path="$HOME/.cache/weather"

# functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function get_all() {
    jq -r . "$cache_path"
}

function get_value() {
    filter="$1"
    jq -r "$filter" "$cache_path"
}

function get_location() {
    place=$(jq -r .name "$cache_path")
    state=$(jq -r .sys.country "$cache_path")
    echo "${place}, ${state}"
}

function get_icon() {
    conditions=$(get_value ".weather[0].main")
    case $conditions in
    Thunderstorm) echo 🌩 ;;
    Drizzle) echo 🌧 ;;
    Rain) echo 🌧 ;;
    Snow) echo ❄ ;;
    Atmosphere) echo 🌁 ;;
    Clear) echo ☀ ;;
    Clouds) echo ⛅ ;;
    Mist) echo 🌫 ;;
    Overcast) echo ☁ ;;
    *) echo "❓$conditions" ;;
    esac
}

function get_summary() {
    icon=$(get_icon)
    status=$(get_value ".weather[0].description")
    humidity=$(get_value ".main.humidity")
    pressure=$(get_value ".main.pressure")

    temp_float=$(get_value ".main.temp")
    temp_int=$(printf "%.0f" "$temp_float")

    echo "${icon} ${status}"
    echo "🌡 ${temp_int}°C"
    echo "🌢 ${humidity}%"
    echo "🡇 ${pressure} hPa"
}

# FIXME not currently used with anything
function get_icon_path() {
    icons_path="/usr/share/icons/Papirus-Dark/symbolic/status"
    icon="clear"
    echo "${icons_path}/weather-${icon}-symbolic.svg"
}

# execution ********************************************************************
case $1 in
'') get_all ;;
summary) get_summary ;;
status) get_value ".weather[0].description" ;;
temp) get_value ".main.temp" ;;
humidity) get_value ".main.humidity" ;;
pressure) get_value ".main.pressure" ;;
wind) get_value ".wind.speed" ;;
location) get_location ;;
icon) get_icon ;;
icon_path) get_icon_path ;;
*) get_value ".$1" ;;
esac
