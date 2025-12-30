#!/bin/bash
set -e

echo "▶ OpenMVG processing started ... \n"

echo " --- Inicjalizacja sceny z katalogu zdjęć"
# -i : katalog ze zdjęciami
# -o : katalog wyjściowy OpenMVG
# -d : baza szerokości sensorów (dla EXIF)
openMVG_main_SfMInit_ImageListing \
  -i /input/photos \
  -o openmvg \
  -d sensor_width_database.txt

echo " --- Obliczanie cech (features) dla każdego zdjęcia"
  ## -i : sfm_data.json wygenerowany w poprzednim kroku
  ## -o : katalog wyjściowy cech
openMVG_main_ComputeFeatures \
  -i openmvg/sfm_data.json \
  -o openmvg

echo " --- Dopasowanie cech (matching)"
  ## Tworzy listę par zdjęć z dopasowanymi punktami
  ## -i : sfm_data.json
  ## -o : katalog wyjściowy matching
openMVG_main_ComputeMatches \
  -i openmvg/sfm_data.json \
  -o openmvg

echo " --- SfM – rekonstrukcja pozycji kamer i wstępny 3D punktów"
  ## Incremental SfM – metoda przyrostowa
  ## -i : sfm_data.json
  ## -m : katalog z matchami
  ## -o : katalog wyjściowy SfM
openMVG_main_IncrementalSfM \
  -i openmvg/sfm_data.json \
  -m openmvg \
  -o openmvg/sfm

echo " --- Konwersja danych OpenMVG do formatu OpenMVS"
  ## -i : sfm_data.bin wygenerowany przez SfM
  ## -o : plik .mvs dla OpenMVS
openMVG_main_openMVG2openMVS \
  -i openmvg/sfm/sfm_data.bin \
  -o openmvs/scene.mvs

test -f openmvg/output/sfm_data.bin || exit 1

echo "▶ OpenMVG processing finished!"