#!/bin/bash
set -e

echo -e "▶ OpenMVS processing started ... \n"

# DensifyPointCloud – zagęszcza chmurę punktów z SfM
DensifyPointCloud scene.mvs --resolution-level 2 --min-resolution 640 --max-resolution 1280 --max-threads 1

# ReconstructMesh – buduje siatkę (mesh) na podstawie gęstej chmury punktów
ReconstructMesh openmvs/scene_dense.mvs

# TextureMesh – nakłada tekstury na siatkę (UV mapping + kolor)
TextureMesh openmvs/scene_dense_mesh.mvs

echo -e "▶ OpenMVS processing finished!"