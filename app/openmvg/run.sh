#!/bin/bash
set -e

echo -e "▶ OpenMVG processing started ... \n"

mkdir -p result

echo -e " --- Inicjalizacja sceny z katalogu zdjęć ---\n"
# -i : katalog ze zdjęciami
# -o : katalog wyjściowy OpenMVG
# -d : baza szerokości sensorów (dla EXIF)
openMVG_main_SfMInit_ImageListing \
  -i /input/photos \
  -o result \
  -f 1000  # przykładowa ogniskowa w pikselach
# fallback: automatyczne oszacowanie ogniskowej
#  -f 0
#  -d sensor_width_database.txt
echo -e "--- Finished\n"

echo -e "--- Obliczanie cech (features) dla każdego zdjęcia ---\n"
  ## -i : sfm_data.json wygenerowany w poprzednim kroku
  ## -o : katalog wyjściowy cech
openMVG_main_ComputeFeatures \
  -i result/sfm_data.json \
  -o result \
  --describerMethod SIFT \
  --force 1
echo -e "--- Finished\n"

echo -e "--- Dopasowanie cech (matching) ---\n"
openMVG_main_ComputeMatches \
  -i result/sfm_data.json \
  -o result \
  --force 1
echo -e "--- Finished\n"

echo -e "--- SfM – rekonstrukcja pozycji kamer i wstępny 3D punktów ---\n"
openMVG_main_IncrementalSfM \
  -i result/sfm_data.json \
  -m result \
  -o result/sfm
echo -e "--- Finished\n"

echo -e "--- Konwersja danych OpenMVG do formatu OpenMVS ---\n"
openMVG_main_openMVG2openMVS \
  -i result/sfm/sfm_data.bin \
  -o result/scene.mvs
  --rotation 1,0,0,-90  # Obrót X: -90° (Z-up → Y-up)

echo -e "--- Finished\n"

test -f result/sfm_data.bin || exit 1

echo -e "▶ OpenMVG processing finished!\n"