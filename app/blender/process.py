import bpy
import os

# 1. Wyczyść scenę
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

# 2. Importuj REFINED OBJ
obj_path = "/app/openmvs/scene_refined_texture.obj"
bpy.ops.wm.obj_import(filepath=obj_path)

# 3. Napraw normalne (na wszelki wypadek)
for obj in bpy.data.objects:
    if obj.type == 'MESH':
        bpy.context.view_layer.objects.active = obj
        bpy.ops.object.mode_set(mode='EDIT')
        bpy.ops.mesh.select_all(action='SELECT')
        bpy.ops.mesh.normals_make_consistent(inside=False)
        bpy.ops.object.mode_set(mode='OBJECT')

# 4. Eksport GLB (stary operator)
bpy.ops.export_scene.gltf(
    filepath="/app/blender/product.glb",
    export_format='GLB'
)

print("Done: product.glb created")