import bpy
import math
import os

# 1. Wyczyść scenę
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

# 2. Importuj REFINED OBJ
obj_path = "/app/openmvs/scene_refined_texture.obj"
bpy.ops.wm.obj_import(filepath=obj_path)

# 3. NAPRAW WSZYSTKIE TRANSFORMACJE
for obj in bpy.data.objects:
    if obj.type == 'MESH':
        print(f"Processing {obj.name}:")
        print(f"  Scale before: {obj.scale}")
        print(f"  Rotation before: {obj.rotation_euler}")

        # 3a. WYMUŚ dodatnią skalę
        obj.scale = (
            abs(obj.scale.x),
            abs(obj.scale.y),
            abs(obj.scale.z)
        )

        # 3b. Zresetuj rotację
        obj.rotation_euler = (0, 0, 0)

        # 3c. ODWRÓĆ jeśli potrzeba (cały mesh, nie normalne)
        # Sprawdź bounding box
        bbox = [obj.matrix_world @ v.co for v in obj.data.vertices]
        avg_z = sum(v.z for v in bbox) / len(bbox)

        # Jeśli średnia Z jest ujemna, obróć mesh
        if avg_z < 0:
            print(f"  Mesh upside down (avg_z={avg_z:.2f}), rotating 180° X")
            obj.rotation_euler.x = math.radians(180)

        print(f"  Scale after: {obj.scale}")

# 4. ZASTOSUJ transformacje (KLUCZOWE!)
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)

# 4. Eksport GLB (stary operator)
bpy.ops.export_scene.gltf(
    filepath="/app/blender/product.glb",
    export_format='GLB',
    export_yup=True
)

print("Done: product.glb created")