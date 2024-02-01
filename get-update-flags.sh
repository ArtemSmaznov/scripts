#!/usr/bin/env bash
checkupdates | grep -q "wine"      && flag+=w
checkupdates | grep -q "mesa"      && flag+=m
checkupdates | grep -q "linux-zen" && flag+=k

echo "$flag"
