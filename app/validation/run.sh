#!/bin/bash
set -euo pipefail

echo -e "# Checking input directory $1 ..."

image_count=$(find $1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | wc -l)

if [ "$image_count" -eq 0 ]; then
    echo -e "❌ No images found in $1. Exiting pipeline."
    exit 1
fi

echo -e "# Checking input directory $1 !\n"