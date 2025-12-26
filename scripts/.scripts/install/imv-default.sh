#!/bin/bash

# Set imv as the default image viewer for common image formats
image_types=(
    "image/png"
    "image/jpeg"
    "image/jpg"
    "image/gif"
    "image/webp"
    "image/bmp"
    "image/tiff"
    "image/x-icon"
    "image/svg+xml"
    "image/x-portable-pixmap"
    "image/x-portable-graymap"
    "image/x-portable-bitmap"
)

echo "Setting imv as default image viewer..."

for mime_type in "${image_types[@]}"; do
    xdg-mime default imv.desktop "$mime_type"
    echo "✓ Set $mime_type to open with imv"
done

echo "Done! All common image formats now open with imv."
