#!/usr/bin/env bash

# Combine options and silence xkbcomp warnings
setxkbmap -option "caps:swapescape,altwin:swap_alt_win" 2>/dev/null

# setxkbmap -option caps:swapescape
# setxkbmap -option altwin:swap_alt_win
