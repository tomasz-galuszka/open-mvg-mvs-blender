#!/bin/bash
set -e

echo "-- MODULES CHECK --"

echo "\n▶ Blender"
blender --background --python-expr "import bpy; print(bpy.app.version_string)"

echo "\n▶ OPENMVG"
openMVG_main_SfMInit_ImageListing --help | head -n 2
openMVG_main_ComputeFeatures --help | head -n 2
openMVG_main_ComputeMatches --help | head -n 2
openMVG_main_IncrementalSfM --help | head -n 2

echo "\n▶ OPENMVS"
DensifyPointCloud --help | head -n 2
ReconstructMesh --help | head -n 2
RefineMesh --help | head -n 2
TextureMesh --help | head -n 2
openMVG_main_openMVG2openMVS --help | head -n 2

echo "\n▶ CGAL"
dpkg -l | grep cgal

echo "\n▶ VCG linked with OPENMVS"
strings $(which ReconstructMesh) | grep -i vcg | head

echo "\n▶ EIGEN"
dpkg -l | grep eigen

echo "\n▶ NODE & NPM"
node --version
npm --version

echo "\n▶ GLTF-TRANSFORM"
gltf-transform --version

echo "\n▶ Python3 & PIP3"
python3 --version
pip3 --version

echo "✅ ALL MODULES CHECKED"