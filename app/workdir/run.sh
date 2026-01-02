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
    -o matches \
    -f 1500 \
    --camera_model 3 \
    --group_camera_model 1 \
    --use_pose_prior 0
echo -e "✔ Scene initialization: FINISHED!\n"

echo -e "▶ Calculate features for each image STARTED...\n"
openMVG_main_ComputeFeatures \
    -p HIGH \
    -i /app/workdir/matches/sfm_data.json \
    -o /app/workdir/matches \
    -m SIFT \
    --describerPreset HIGH \
    --force 1
echo -e "✔ Calculate features for each image: FINISHED!\n"

openMVG_main_PairGenerator \
  -i /app/workdir/matches/sfm_data.json \
  -o /app/workdir/matches/pairs.bin

echo -e "▶ Features matching STARTED ---\n"
mkdir -p matches
openMVG_main_ComputeMatches \
    -r .8 \
    -i /app/workdir/matches/sfm_data.json \
    -p /app/workdir/matches/pairs.bin \
    -o /app/workdir/matches/matches.putative.bin \
    --force 1
echo -e "✔ Features matching: FINISHED!\n"

openMVG_main_GeometricFilter \
  -i /app/workdir/matches/sfm_data.json \
  -m /app/workdir/matches/matches.putative.bin \
  -g f \
  -o /app/workdir/matches/matches.f.bin

echo -e "▶ SfM camera and 3D points reconstruction STARTED...\n"
openMVG_main_SfM -s INCREMENTAL \
    --input_file /app/workdir/matches/sfm_data.json \
    -o /app/workdir/matches/sfm/ \
    --match_dir /app/workdir/matches
echo -e "✔ SfM camera and 3D points reconstruction: FINISHED!\n"

echo -e "▶ Conversion OpenMVG -> OpenMVS format STARTED...\n"
mkdir -p "$OPENMVS_DIR"
openMVG_main_openMVG2openMVS \
    -i /app/workdir/matches/sfm/sfm_data.bin \
    -o $OPENMVS_DIR/scene.mvs
echo -e "✔ Conversion OpenMVG -> OpenMVS format: FINISHED!\n"

echo -e "=============================================="
echo -e "✔ OpenMVG processing FINISHED!\n"
echo -e "=============================================="

SCRIPT_DIR="/app/openmvs"
ORIG_DIR="$(pwd)"

echo "Changing to $SCRIPT_DIR"
pushd "$SCRIPT_DIR" > /dev/null

./run.sh

echo "Returning to $ORIG_DIR"
popd > /dev/null

SCRIPT_DIR="/app/blender"
ORIG_DIR="$(pwd)"

echo "Changing to $SCRIPT_DIR"
pushd "$SCRIPT_DIR" > /dev/null

./run.sh

echo "Returning to $ORIG_DIR"
popd > /dev/null

SCRIPT_DIR="/app/gltf_transform"
ORIG_DIR="$(pwd)"

echo "Changing to $SCRIPT_DIR"
pushd "$SCRIPT_DIR" > /dev/null

./run.sh

echo "Returning to $ORIG_DIR"
popd > /dev/null

echo -e "✔ PIPELINE DONE"
