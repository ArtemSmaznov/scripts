#!/usr/bin/env bash

bluetoothctl devices Connected |
    awk '{ print $3 }'
