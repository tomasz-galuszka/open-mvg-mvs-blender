#!/bin/bash
set -e

echo "▶ OpenMVG"
./openmvg/run_openmvg.sh

echo "▶ OpenMVS"
./openmvs/run_openmvs.sh

echo "▶ Blender cleanup"
blender --background --python process.py

echo "▶ glTF optimize"
gltf-transform optimize output/product.glb output/product_final.glb --draco --texture-compress webp --texture-size 2048

echo "✔ DONE"
