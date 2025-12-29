#!/bin/bash

set -e

echo "▶ OpenMVG"
./openmvg/run_openmvg.sh

echo "▶ OpenMVS"
./openmvs/run_openmvs.sh

echo "▶ Blender cleanup"
/Applications/Blender.app/Contents/MacOS/Blender --background --python process.py

echo "▶ glTF optimize"
gltf-transform optimize output/product.glb output/product_final.glb --draco

echo "✔ DONE"
