#!/bin/bash
set -e

echo "-- MODULEC CHECK --"

echo "\n▶ Blender"
blender --background --python-expr "import bpy; print(bpy.app.version_string)"

echo "\n▶ OPENMVG"
openMVG_main_SfMInit_ImageListing --help | head -n 5
openMVG_main_ComputeFeatures --help | head -n 5
openMVG_main_ComputeMatches --help | head -n 5
openMVG_main_IncrementalSfM --help | head -n 5

echo "\n▶ OPENMVS"
DensifyPointCloud --help | head -n 10
ReconstructMesh --help | head -n 10
RefineMesh --help | head -n 10
TextureMesh --help | head -n 10

echo "\n▶ CGAL"
dpkg -l | grep cgal

echo "\n▶ VCG"
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