#!/usr/bin/env bash
kernel=linux-zen
gpu=amd

case $gpu in
    nvidia) gpu_driver=nvidia ;;
    amd) gpu_driver=mesa ;;
esac

checkupdates | grep -q "$gpu_driver"  && flag+=m
checkupdates | grep -q "$kernel"      && flag+=k

echo "$flag"
