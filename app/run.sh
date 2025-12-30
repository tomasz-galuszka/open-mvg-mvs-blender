#!/bin/bash
set -euo pipefail

echo -e "▶ PIPELINE STARTED ..."
echo -e ""

# -----------------------------------------------
# ▶ Sprawdzenie katalogu z obrazkami
# -----------------------------------------------
echo -e "# Checking input directory /input/photos ..."

# Liczymy pliki z rozszerzeniami .jpg, .jpeg, .png
image_count=$(find /input/photos -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | wc -l)

if [ "$image_count" -eq 0 ]; then
    echo -e "❌ No images found in /input/photos. Exiting pipeline."
    exit 1
fi

echo -e "# Checking input directory /input/photos !\n"

./openmvg/run.sh
./openmvs/run.sh
./blender/run.sh
./gltf_transform/run.sh

echo -e ""
echo -e "✔ PIPELINE DONE"
