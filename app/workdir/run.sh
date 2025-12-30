#!/bin/bash
set -euo pipefail

export INPUT_IMAGES="/input/photos"
export INPUT_IMAGES_LOCAL="/app/workdir"
export OPENMVS_DIR="/app/openmvs"

echo -e "▶ PIPELINE STARTED ...\n"

../validation/run.sh "$INPUT_IMAGES"

echo -e "▶ Copy $INPUT_IMAGES to $INPUT_IMAGES_LOCAL started...\n"
cp "$INPUT_IMAGES"/* "$INPUT_IMAGES_LOCAL"
echo -e "✔ Copy FINISHED!\n"

cd "$INPUT_IMAGES_LOCAL"

echo -e "=============================================="
echo -e "▶ OpenMVG processing STARTED ... \n"
echo "=============================================="

echo -e "▶ Scene initialization STARTED...\n"
openMVG_main_SfMInit_ImageListing \
    -i . \
    -o . \
    -f 0 \
    --camera_model 3 \
    --group_camera_model 1 \
    --use_pose_prior 0
echo -e "✔ Scene initialization: FINISHED!\n"

echo -e "▶ Calculate features for each image STARTED...\n"
openMVG_main_ComputeFeatures \
    -i sfm_data.json \
    -o . \
    --describerMethod SIFT \
    --force 1
echo -e "✔ Calculate features for each image: FINISHED!\n"

echo -e "▶ Features matching STARTED ---\n"
openMVG_main_ComputeMatches \
    -i sfm_data.json \
    -o . \
    --force 1
echo -e "✔ Features matching: FINISHED!\n"

echo -e "▶ SfM camera and 3D points reconstruction STARTED...\n"
mkdir -p sfm
openMVG_main_SfM \
    -i sfm_data.json \
    -m . \
    -o sfm
echo -e "✔ SfM camera and 3D points reconstruction: FINISHED!\n"

echo -e "▶ Conversion OpenMVG -> OpenMVS format STARTED...\n"
mkdir -p "$OPENMVS_DIR"
openMVG_main_openMVG2openMVS \
    -i sfm/sfm_data.bin \
    -o "$OPENMVS_DIR/scene.mvs"
echo -e "✔ Conversion OpenMVG -> OpenMVS format: FINISHED!\n"

echo -e "=============================================="
echo -e "✔ OpenMVG processing FINISHED!\n"
echo -e "=============================================="

# ./openmvs/run.sh
# ./blender/run.sh
# ./gltf_transform/run.sh

echo -e "✔ PIPELINE DONE"
