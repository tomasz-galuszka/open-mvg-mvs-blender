#!/bin/bash
set -e

echo -e "▶ Blender optimization started ... \n"

blender --background --python process.py

echo -e "▶ Blender optimization finished!"