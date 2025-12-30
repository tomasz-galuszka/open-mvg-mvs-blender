#!/bin/bash
set -e

echo -e "▶ glTF optimization started\n"

# Komenda gltf-transform optimize:
# - input: output/product.glb            → plik GLB wygenerowany przez Blender
# - output: output/product_final.glb    → zoptymalizowany plik docelowy
# - --draco                            → włącza kompresję geometrii Draco (redukcja rozmiaru siatki)
# - --texture-compress webp            → kompresuje tekstury do formatu WebP (redukcja rozmiaru tekstur)
# - --texture-size 2048                 → ustala maksymalny rozmiar tekstur na 2048 px
gltf-transform optimize \
  output/product.glb \
  output/product_final.glb \
  --draco \
  --texture-compress webp \
  --texture-size 2048

echo -e "▶ glTF optimization finished!"