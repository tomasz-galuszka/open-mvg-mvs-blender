import bpy
import os
import sys

print("# Blender processing started ...")

# ------------------------------------------------------
# 1. ZAŁADUJ WYMAGANE ADDONY (KLUCZOWE!)
print("Loading required addons...")

# Włącz addon importu PLY
try:
    # Sprawdź czy addon jest dostępny
    bpy.ops.preferences.addon_enable(module="io_import_dxf")
    # Dla PLY czasem jest inny moduł
except:
    pass

# Włącz addon GLTF/GLB eksportu
try:
    bpy.ops.preferences.addon_enable(module="io_scene_gltf2")
except:
    pass

# ------------------------------------------------------
# 2. Wyczyść scenę
print("Cleaning scene...")
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)

# ------------------------------------------------------
# 3. Import PLY
input_ply = "/app/openmvs/scene_dense_mesh_texture.ply"
print(f"Importing PLY: {input_ply}")

# Sprawdź czy plik istnieje
if not os.path.exists(input_ply):
    print(f"ERROR: File not found: {input_ply}")
    sys.exit(1)

# Spróbuj różne metody importu PLY
try:
    # Metoda 1: Standardowy import PLY
    bpy.ops.import_mesh.ply(filepath=input_ply)
    print("  PLY import successful (import_mesh.ply)")

except AttributeError:
    # Metoda 2: Nowy operator w Blender 4.0
    try:
        bpy.ops.wm.ply_import(filepath=input_ply)
        print("  PLY import successful (wm.ply_import)")
    except:
        # Metoda 3: Ręczne ładowanie
        print("  Using manual PLY loading...")
        try:
            # Importuj używając bpy.ops.import_scene
            bpy.ops.import_scene.ply(filepath=input_ply)
            print("  PLY import successful (import_scene.ply)")
        except Exception as e:
            print(f"  ERROR: All PLY import methods failed: {e}")
            sys.exit(1)

except Exception as e:
    print(f"  ERROR importing PLY: {e}")
    sys.exit(1)

# ------------------------------------------------------
# 4. Sprawdź co zostało zaimportowane
imported_meshes = [obj for obj in bpy.data.objects if obj.type == 'MESH']
print(f"Imported {len(imported_meshes)} mesh objects")

if not imported_meshes:
    print("ERROR: No meshes imported")
    sys.exit(1)

for obj in imported_meshes:
    print(f"  - {obj.name}: {len(obj.data.polygons):,} faces")

# ------------------------------------------------------
# 5. Szukaj tekstur
texture_dir = os.path.dirname(input_ply)
base_name = os.path.splitext(os.path.basename(input_ply))[0]

texture_files = []
texture_extensions = ['.jpg', '.png', '.jpeg', '.tga', '.bmp']

# Szukaj plików tekstur
for f in os.listdir(texture_dir):
    f_lower = f.lower()
    # OpenMVS pattern: scene_dense_mesh_texture_0.jpg
    if f_lower.startswith(base_name.lower()):
        for ext in texture_extensions:
            if f_lower.endswith(ext):
                texture_files.append(os.path.join(texture_dir, f))
                break
    # Może też być: texture_0.jpg, texture_kd.jpg, etc.
    elif 'texture' in f_lower:
        for ext in texture_extensions:
            if f_lower.endswith(ext):
                texture_files.append(os.path.join(texture_dir, f))
                break

print(f"Found {len(texture_files)} texture files")
for tex in texture_files[:5]:  # Pokaz pierwsze 5
    print(f"  - {os.path.basename(tex)}")
if len(texture_files) > 5:
    print(f"  ... and {len(texture_files) - 5} more")

# ------------------------------------------------------
# 6. Przypisz tekstury do materiałów
if texture_files:
    print("\nAssigning textures to materials...")

    for obj in imported_meshes:
        if obj.data.materials:
            for i, mat in enumerate(obj.data.materials):
                if mat:
                    # Włącz node-based materials
                    mat.use_nodes = True

                    # Szukaj odpowiedniej tekstury
                    texture_to_use = None
                    if i < len(texture_files):
                        texture_to_use = texture_files[i]
                    elif texture_files:  # Użyj pierwszej tekstury dla wszystkich
                        texture_to_use = texture_files[0]

                    if texture_to_use and os.path.exists(texture_to_use):
                        try:
                            # Załaduj obraz
                            img = bpy.data.images.load(texture_to_use)

                            # Utwórz node z teksturą
                            nodes = mat.node_tree.nodes
                            tex_node = nodes.new('ShaderNodeTexImage')
                            tex_node.image = img
                            tex_node.location = (-300, 300)

                            # Połącz z BSDF
                            bsdf = nodes.get("Principled BSDF")
                            if bsdf:
                                mat.node_tree.links.new(
                                    tex_node.outputs['Color'],
                                    bsdf.inputs['Base Color']
                                )

                            print(f"    Assigned texture to {obj.name}/material_{i}: {os.path.basename(texture_to_use)}")
                        except Exception as e:
                            print(f"    WARNING: Could not load texture {texture_to_use}: {e}")

# ------------------------------------------------------
# 7. OPTIONAL: Decimation (wyłączone domyślnie)
apply_decimation = False
if apply_decimation:
    print("\nApplying decimation...")
    decimation_ratio = 0.3

    for obj in imported_meshes:
        original_faces = len(obj.data.polygons)
        if original_faces > 10000:  # Tylko duże meshe
            bpy.context.view_layer.objects.active = obj

            # Dodaj modyfikator
            modifier = obj.modifiers.new(name="Decimate", type='DECIMATE')
            modifier.ratio = decimation_ratio

            # Zastosuj
            bpy.ops.object.modifier_apply(modifier=modifier.name)

            new_faces = len(obj.data.polygons)
            print(f"  {obj.name}: {original_faces:,} → {new_faces:,} faces")

# ------------------------------------------------------
# 8. Eksport do GLB
output_glb = "/app/blender/product.glb"
print(f"\nExporting GLB to: {output_glb}")

# Utwórz katalog
os.makedirs(os.path.dirname(output_glb), exist_ok=True)

# Spróbuj różne metody eksportu
try:
    # Metoda 1: Nowy operator (Blender 4.0+)
    bpy.ops.wm.gltf_export(
        filepath=output_glb,
        export_format='GLB',
        export_yup=True,
        export_apply=True,
        export_texcoords=True,
        export_normals=True,
        export_materials='EXPORT',
        use_selection=False
    )
    print("  GLB export successful (wm.gltf_export)")

except AttributeError:
    # Metoda 2: Stary operator
    try:
        bpy.ops.export_scene.gltf(
            filepath=output_glb,
            export_format='GLB',
            export_yup=True,
            export_apply=True,
            export_materials='EXPORT'
        )
        print("  GLB export successful (export_scene.gltf)")
    except Exception as e:
        print(f"  ERROR exporting GLB: {e}")
        sys.exit(1)

except Exception as e:
    print(f"  ERROR exporting GLB: {e}")
    sys.exit(1)

# ------------------------------------------------------
# 9. Sprawdź wynik
if os.path.exists(output_glb):
    file_size = os.path.getsize(output_glb) / (1024 * 1024)
    print(f"\n✓ SUCCESS: Created {output_glb}")
    print(f"  File size: {file_size:.2f} MB")

    # Statystyki
    total_faces = sum(len(obj.data.polygons) for obj in imported_meshes)
    total_verts = sum(len(obj.data.vertices) for obj in imported_meshes)
    print(f"  Mesh stats: {total_faces:,} faces, {total_verts:,} vertices")
else:
    print(f"\n✗ ERROR: Failed to create {output_glb}")

print("\n# Blender processing completed!")