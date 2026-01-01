#!/bin/bash
set -e

echo -e "▶ OpenMVS processing started ... \n"

# DensifyPointCloud – zagęszcza chmurę punktów z SfM
DensifyPointCloud scene.mvs --resolution-level 2 --min-resolution 640 --max-resolution 1280 --max-threads 2

# ReconstructMesh – buduje siatkę (mesh) na podstawie gęstej chmury punktów
ReconstructMesh -i scene_dense.mvs --archive-type=2

# TextureMesh – nakłada tekstury na siatkę (UV mapping + kolor)
TextureMesh scene_dense_mesh.mvs --archive-type=2

# Ekspport do blendera // nie działa
TransformScene \
  --input-file=scene_dense_mesh_texture.mvs \
  --mesh-file=scene_dense_mesh_texture.ply \
  --output-file=scene.obj \
  --export-type=obj

echo -e "▶ OpenMVS processing finished!"