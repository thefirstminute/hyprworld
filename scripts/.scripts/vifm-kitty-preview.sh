#!/bin/bash
# Clear previous previews
kitty +kitten icat --clear

# Show current file if it's an image
if file --mime-type "$1" | grep -qE 'image/(png|jpeg|gif|bmp|webp)'; then
    kitty +kitten icat "$1"
fi
