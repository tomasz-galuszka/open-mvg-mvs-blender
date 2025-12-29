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

## OpenMVG
```bash
brew install opencv
git clone --recursive https://github.com/openMVG/openMVG.git

mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(sysctl -n hw.ncpu)
# Po kompilacji binaria znajdziesz w openMVG_Build/Linux-x86_64-RELEASE/bin/ (nazwa katalogu może się różnić w zależności od wersji / OSX)

# Zmienna w bin
export PATH="$PATH:/path/to/openMVG_Build/Linux-x86_64-RELEASE/bin"
```

## OpenMVS
```bash
brew install cmake git boost glew eigen
brew install opencv

## Uwaga: OpenMVS wymaga Boost i OpenCV (ta sama wersja, co w OpenMVG)

git clone --recursive https://github.com/cdcseacave/OpenMVS.git
cd OpenMVS

mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(sysctl -n hw.ncpu)

# Po kompilacji binaria będą w bin/

export PATH="$PATH:/path/to/OpenMVS/build/bin"
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