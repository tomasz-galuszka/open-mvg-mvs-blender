#!/bin/bash
set -euo pipefail

export INPUT_IMAGES="/input/photos"
export INPUT_IMAGES_LOCAL="/app/input_photos_local"
export RESULT_DIR="$INPUT_IMAGES_LOCAL"
export OPENMVS_DIR="/app/openmvs"

echo -e "▶ PIPELINE STARTED ...\n"
./validation/run.sh ${INPUT_IMAGES}

echo -e "▶ Copy ${INPUT_IMAGES} to ${INPUT_IMAGES_LOCAL} started... ---\n"
mkdir -p "$INPUT_IMAGES_LOCAL"
cp $INPUT_IMAGES/* "$INPUT_IMAGES_LOCAL"
echo -e "✔ Copy FINISHED!\n"

echo "=============================================="
echo -e "▶ OpenMVG processing STARTED ... \n"
echo "=============================================="

echo -e "▶ Scene initialization STARTED...\n"
openMVG_main_SfMInit_ImageListing \
    -i "$INPUT_IMAGES_LOCAL" \
    -o "$RESULT_DIR" \
    -f 0 \
    --camera_model 3 \
    --group_camera_model 1 \
    --use_pose_prior 0
echo -e "✔ Scene initialization: FINISHED!\n"

echo -e "▶ Calculate features for each image STARTED...\n"
openMVG_main_ComputeFeatures \
    -i "$RESULT_DIR/sfm_data.json" \
    -o "$RESULT_DIR" \
    --describerMethod SIFT \
    --force 1
echo -e "✔ Calculate features for each image: FINISHED!\n"

echo -e "▶ Features matching STARTED ---\n"
openMVG_main_ComputeMatches \
    -i "$RESULT_DIR/sfm_data.json" \
    -o "$RESULT_DIR" \
    --force 1
echo -e "✔ Features matching: FINISHED!\n"

echo -e "▶ SfM camera and 3d points initial reconstruction STARTED...\n"
openMVG_main_IncrementalSfM \
    -i "$RESULT_DIR/sfm_data.json" \
    -m "$RESULT_DIR" \
    -o "$RESULT_DIR/sfm"
echo -e "✔ SfM camera and 3d points initial reconstruction: FINISHED!\n"

echo -e "▶ Conversion OpenMVG to OpenMVS format STARTED...\n"
openMVG_main_openMVG2openMVS \
    -i "$RESULT_DIR/sfm/sfm_data.bin" \
    -o "$OPENMVS_DIR/scene.mvs"
echo -e "✔ Conversion OpenMVG to OpenMVS format: FINISHED!\n"

echo "=============================================="
echo -e "✔ OpenMVG processing FINISHED!\n"
echo "=============================================="

#./openmvs/run.sh
#./blender/run.sh
#./gltf_transform/run.sh

echo -e "✔ PIPELINE DONE"
