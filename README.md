# OpenVMG + OpenMVS

```
┌──────────────────────────┐
│  Folder wejściowy        │
│  (JPEG / PNG)            │
│  photos/                 │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│ OpenMVG                  │
│ Structure from Motion    │
│                          │
│ - feature extraction     │
│ - matching               │
│ - camera poses           │
│ - sparse point cloud     │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│ OpenMVS                  │
│ Multi View Stereo        │
│                          │
│ - dense point cloud      │
│ - mesh reconstruction    │
│ - texture generation     │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│ Mesh Cleanup / Convert   │
│ (Blender headless)       │
│                          │
│ - decimation             │
│ - normals                │
│ - UV fix                 │
│ - scale / orientation    │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│ glTF Optimization        │
│ (glTF-Transform)         │
│                          │
│ - Draco                  │
│ - Meshopt                │
│ - texture resize         │
│ - remove unused data     │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│ Final Output              │
│ product.glb               │
│ (ready for web & AR)      │
└──────────────────────────┘

```

## Blender headles
```bash
# Sprawdź wersję Blendera
/Applications/Blender.app/Contents/MacOS/Blender --version

# Uruchom skrypt Python w trybie background (bez GUI)
/Applications/Blender.app/Contents/MacOS/Blender --background --python process.py
```

## Links
- https://peterfalkingham.com/2018/05/22/photogrammetry-testing-12-revisiting-openmvg-with-openmvs/
- https://www.zalando.pl/adidas-originals-samba-og-sneakersy-niskie-marooncream-whitegold-coloured-metallic-ad111a31i-o11.html
- https://github.com/openMVG/openMVG
- https://github.com/cdcseacave/openMVS
- https://github.com/cnr-isti-vclab/meshlab
- https://github.com/assimp/assimp
- https://github.com/donmccurdy/glTF-Transform
- https://github.com/google/draco
- https://www.blender.org/download/