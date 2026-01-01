#!/bin/bash
set -e

echo -e "▶ OpenMVS processing started ... \n"

# DensifyPointCloud – zagęszcza chmurę punktów z SfM
DensifyPointCloud scene.mvs --resolution-level 2 --min-resolution 640 --max-resolution 1280 --max-threads 2

# ReconstructMesh – buduje siatkę (mesh) na podstawie gęstej chmury punktów
ReconstructMesh -i scene_dense.mvs --archive-type=2

# TextureMesh – nakłada tekstury na siatkę (UV mapping + kolor)
TextureMesh scene_dense_mesh.mvs --archive-type=2

blender --background --python-expr "
import bpy

# Włącz dodatek PLY
bpy.ops.preferences.addon_enable(module='io_mesh_ply')

# Usuń scenę domyślną
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

# Import PLY
bpy.ops.import_mesh.ply(filepath='/app/openmvs/scene_dense_mesh_texture.ply')

# Eksport do OBJ z zachowaniem UV
bpy.ops.export_scene.obj(filepath='/app/openmvs/scene.obj', use_materials=True, use_uvs=True)
"

echo -e "▶ OpenMVS processing finished!"