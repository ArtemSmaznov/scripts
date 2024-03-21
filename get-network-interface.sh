#!/usr/bin/env bash
route |
    awk '$1 == "default" {print $8}' |
    head -1
