#!/usr/bin/env bash

# ============================================================
#  Wayland Automation Toolkit (Nota Edition)
#  Functions:
#    - get_mouse_pos
#    - click_left
#    - click_right
#    - key
#    - type_text
#    - sleep_ms
# ============================================================

# --- CONFIG --------------------------------------------------

YDO="ydotool"
SLURP="slurp"

# --- HELPERS -------------------------------------------------

sleep_ms() {
    # sleep in milliseconds
    local ms="$1"
    sleep "$(printf "%s/1000" "$ms" | bc -l)"
}

# --- INPUT FUNCTIONS -----------------------------------------

select_window() {
    # Uses slurp to select a point and prints x y
    echo "Select a point..."
    local out
    out="$($SLURP -f "%x %y")"
    echo "$out"
}

get_mouse_pos() {
    # Uses slurp to select a point and prints x y
    echo "Select a point..."
    local out
    out="$($SLURP -p "%x %y")"
    echo "$out"
}

move_mouse() {
    # move_mouse x y
    local x="$1"
    local y="$2"
    $YDO mousemove "$x" "$y"
}

click_left() {
    $YDO click 0
}

click_right() {
    $YDO click 1
}

key() {
    # Send a key by name (ydotool expects keycodes, but names work for common keys)
    # Example: key "CTRL+S"
    $YDO key "$1"
}

type_text() {
    # Types literal text
    local text="$1"
    $YDO type "$text"
}

# --- DEMO ACTIONS --------------------------------------------

demo_sequence() {
    echo "Running demo: click, wait, type..."
    click_left
    sleep_ms 300
    type_text "Hello Nota!"
    sleep_ms 200
    key "ENTER"
}

# --- CLI ------------------------------------------------------

case "$1" in
    win)
        select_window
        ;;
    move)
        move_mouse "$2" "$3"
        ;;
    pos)
        get_mouse_pos
        ;;
    click)
        click_left
        ;;
    rclick)
        click_right
        ;;
    key)
        shift
        key "$*"
        ;;
    type)
        shift
        type_text "$*"
        ;;
    demo)
        demo_sequence
        ;;
    *)
        echo "Wayland Automation Toolkit"
        echo "Usage:"
        echo "  $0 pos            # get mouse position"
        echo "  $0 click          # left click"
        echo "  $0 rclick         # right click"
        echo "  $0 key CTRL+S     # send keystroke"
        echo "  $0 type 'hello'   # type text"
        echo "  $0 demo           # run demo sequence"
        ;;
esac
