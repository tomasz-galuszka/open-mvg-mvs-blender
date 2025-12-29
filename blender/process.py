import bpy

bpy.ops.import_scene.obj(filepath="scene.obj")

# Decimation
for obj in bpy.context.selected_objects:
    mod = obj.modifiers.new(name="Decimate", type='DECIMATE')
    mod.ratio = 0.3

# Apply modifiers
bpy.ops.object.modifier_apply(modifier="Decimate")

# Export GLB
bpy.ops.export_scene.gltf(
    filepath="output/product.glb",
    export_format='GLB',
    export_apply=True
)