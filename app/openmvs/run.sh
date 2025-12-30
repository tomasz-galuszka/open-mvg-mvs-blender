#!/bin/bash
set -e

echo -e "▶ OpenMVS processing started ... \n"

# DensifyPointCloud – zagęszcza chmurę punktów z SfM
  ## input: openmvs/scene.mvs (konwertowane z OpenMVG)
  ## output: openmvs/scene_dense.mvs (gęsta chmura punktów)
DensifyPointCloud openmvs/scene.mvs

# ReconstructMesh – buduje siatkę (mesh) na podstawie gęstej chmury punktów
  ## input: openmvs/scene_dense.mvs
  ## output: openmvs/scene_dense_mesh.mvs
ReconstructMesh openmvs/scene_dense.mvs

# TextureMesh – nakłada tekstury na siatkę (UV mapping + kolor)
  ## input: openmvs/scene_dense_mesh.mvs
  ## output: openmvs/scene_dense_mesh_texture.mvs
TextureMesh openmvs/scene_dense_mesh.mvs

test -f openmvs/output/textured_mesh.obj || exit 1

echo -e "▶ OpenMVS processing finished!"