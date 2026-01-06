#!/bin/bash
set -e

echo -e "▶ OpenMVS processing started ... \n"

echo -e "--- DensifyPointCloud – zagęszcza chmurę punktów z SfM ---\n"
DensifyPointCloud scene.mvs --max-threads 4

echo -e "--- ReconstructMesh – buduje siatkę (mesh) na podstawie gęstej chmury punktów ---\n"
ReconstructMesh -i scene_dense.mvs --archive-type=2

echo -e "--- RefineMesh Popraw normalne jeśli mesh jest odwrócony ---\n"
RefineMesh -i scene_dense_mesh.mvs \
  --ensure-edge-size 1 \
  --close-holes 30 \
  --decimate 0.3 \
  -o scene_refined.mvs

echo -e "--- TextureMesh – nakłada tekstury na siatkę (UV mapping + kolor) ---\n"
TextureMesh scene_refined.mvs --archive-type=2 --export-type OBJ

echo -e "▶ OpenMVS processing finished!"