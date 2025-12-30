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
  ## Tworzy listę par zdjęć z dopasowanymi punktami
  ## -i : sfm_data.json
  ## -o : katalog wyjściowy matching
openMVG_main_ComputeMatches \
  -i result/sfm_data.json \
  -o result \
  --force 1
echo -e "--- Finished\n"

echo -e "--- SfM – rekonstrukcja pozycji kamer i wstępny 3D punktów ---\n"
  ## Incremental SfM – metoda przyrostowa
  ## -i : sfm_data.json
  ## -m : katalog z matchami
  ## -o : katalog wyjściowy SfM
openMVG_main_IncrementalSfM \
  -i result/sfm_data.json \
  -m result \
  -o result/sfm
echo -e "--- Finished\n"

echo -e "--- Konwersja danych OpenMVG do formatu OpenMVS ---\n"
  ## -i : sfm_data.bin wygenerowany przez SfM
  ## -o : plik .mvs dla OpenMVS
openMVG_main_openMVG2openMVS \
  -i result/sfm/sfm_data.bin \
  -o result/scene.mvs
echo -e "--- Finished\n"

test -f result/sfm_data.bin || exit 1

echo -e "▶ OpenMVG processing finished!\n"