import bpy

# -----------------------------------------------
print("# Blender processing started ...")

# Usuń wszystko w scenie (opcjonalne, jeśli Blender nie jest clean)
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

# Import pliku OBJ
input_obj = "scene.obj"
print(f"Importing OBJ: {input_obj}")
bpy.ops.import_scene.obj(filepath=input_obj)

# Decimation (redukcja liczby trójkątów)
decimation_ratio = 0.3
print(f"Applying decimation with ratio: {decimation_ratio}")

for obj in bpy.context.selected_objects:
    if obj.type == 'MESH':
        mod = obj.modifiers.new(name="Decimate", type='DECIMATE')
        mod.ratio = decimation_ratio
        print(f"  Added decimate modifier to object: {obj.name}")

# Apply all modifiers
for obj in bpy.context.selected_objects:
    if obj.type == 'MESH':
        for mod in obj.modifiers:
            bpy.ops.object.modifier_apply(modifier=mod.name)
            print(f"  Applied modifier {mod.name} on object: {obj.name}")

# Export do GLB
output_glb = "output/product.glb"
print(f"Exporting GLB to: {output_glb}")
bpy.ops.export_scene.gltf(
    filepath=output_glb,
    export_format='GLB',
    export_apply=True,
    export_yup=True  # Y-up coordinate system
)

print("# Blender processing finished")