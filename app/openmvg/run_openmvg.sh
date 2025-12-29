echo -e "# OpenMVG STARTED"

openMVG_main_SfMInit_ImageListing \
  -i /input/photos \
  -o openmvg \
  -d sensor_width_database.txt

openMVG_main_ComputeFeatures \
  -i openmvg/sfm_data.json \
  -o openmvg

openMVG_main_ComputeMatches \
  -i openmvg/sfm_data.json \
  -o openmvg

openMVG_main_IncrementalSfM \
  -i openmvg/sfm_data.json \
  -m openmvg \
  -o openmvg/sfm


openMVG_main_openMVG2openMVS \
  -i openmvg/sfm/sfm_data.bin \
  -o openmvs/scene.mvs

echo -e "# OpenMVG FINISHED\n"