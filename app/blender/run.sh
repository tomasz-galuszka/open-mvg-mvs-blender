#!/bin/bash
set -e

echo -e "▶ Blender optimization started ... \n"

blender --background --factory-startup --disable-autoexec --python process.py
test -f output/product.glb || exit 1

echo -e "▶ Blender optimization finished!"