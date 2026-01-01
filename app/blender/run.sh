#!/bin/bash
set -e

echo -e "▶ Blender optimization started ... \n"

blender --background --factory-startup --python process_model.py

echo -e "▶ Blender optimization finished!"