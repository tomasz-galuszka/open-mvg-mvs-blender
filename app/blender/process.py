import bpy
import os

# 1. Wyczyść scenę
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

# 2. Import OBJ z OpenMVS
obj_path = "/app/openmvs/scene_dense_mesh_texture.obj"
bpy.ops.wm.obj_import(filepath=obj_path)

# 3. Optymalizacja (decimation tylko jeśli >10k trójkątów)
for obj in bpy.context.selected_objects:
    if obj.type == 'MESH':
        faces = len(obj.data.polygons)
        if faces > 10000:
            # Zachowaj 50% trójkątów
            mod = obj.modifiers.new(name="Decimate", type='DECIMATE')
            mod.ratio = 0.5
            bpy.ops.object.modifier_apply(modifier=mod.name)
            print(f"Reduced {obj.name}: {faces} -> {len(obj.data.polygons)} faces")

# 4. Eksport GLB (stary operator)
bpy.ops.export_scene.gltf(
    filepath="/app/blender/product.glb",
    export_format='GLB'
)

print("Done: product.glb created")