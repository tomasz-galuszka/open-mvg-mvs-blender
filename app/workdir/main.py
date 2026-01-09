import subprocess

INPUT_IMAGES = "/input/photos/*"
INPUT_IMAGES_LOCAL = "/app/workdir"


def copy_images():
    print("▶ Copy " + INPUT_IMAGES + " to " + INPUT_IMAGES_LOCAL + " STARTED...")
    subprocess.call("cp " + INPUT_IMAGES + " " + INPUT_IMAGES_LOCAL, shell=True)
    print("✔ Copy FINISHED!")


def start_open_mvg_processing():
    print("▶ OpenMVG processing STARTED\n")

    print("▶ 1. Scene initialization: STARTED")
    # 1500 - przykładowa ogniskowa w pikselach
    subprocess.run([
        "openMVG_main_SfMInit_ImageListing",
        "-i", ".",
        "-o", "matches",
        "-f", "1500",
        "--camera_model", "3",
        "--group_camera_model", "1",
        "--use_pose_prior", "0"
    ])
    print("✔ 1. FINISHED")

    print("▶ 2. Calculate features for each image: STARTED")
    subprocess.run([
        "openMVG_main_ComputeFeatures",
        "-p", "HIGH",
        "-i", "/app/workdir/matches/sfm_data.json",
        "-o", "/app/workdir/matches",
        "-m", "SIFT",
        "--describerPreset", "HIGH",
        "--force", "1"
    ])
    print("✔ 2. FINISHED")

    print("▶ 3. Features matching: STARTED")
    subprocess.run(["mkdir", "-p", "matches"])
    subprocess.run([
        "openMVG_main_ComputeMatches",
        "-r", ".8",
        "-i", "/app/workdir/matches/sfm_data.json",
        "-p", "/app/workdir/matches/pairs.bin",
        "-o", "/app/workdir/matches/matches.putative.bin",
        "--force", "1"
    ])
    print("✔ 3. FINISHED")

    print("▶ 4. Geometric filter: STARTED")
    subprocess.run(["mkdir", "-p", "matches"])
    subprocess.run([
        "openMVG_main_GeometricFilter",
        "-i", "/app/workdir/matches/sfm_data.json",
        "-m", "/app/workdir/matches/matches.putative.bin",
        "-g", "f",
        "-o", "/app/workdir/matches/matches.f.bin",
    ])
    print("✔ 4. FINISHED")

    print("▶ 5. SfM camera and 3D points reconstruction: STARTED")
    subprocess.run([
        "openMVG_main_SfM",
        "-s", "INCREMENTAL",
        "-i", "/app/workdir/matches/sfm_data.json ",
        "-o", "/app/workdir/matches/sfm/",
        "-m", "/app/workdir/matches"
    ])
    print("✔ 5. FINISHED")

    print("▶ 6. Conversion OpenMVG -> OpenMVS format: STARTED")
    subprocess.run([
        "openMVG_main_openMVG2openMVS",
        "-i", "/app/workdir/matches/sfm/sfm_data.bin",
        "-o", "/app/workdir/scene.mvs"
    ])
    print("✔ 6. FINISHED")

    print("✔ OpenMVG processing: FINISHED")


def start_open_mvs_processing():
    print("▶ OpenMVS processing: STARTED\n")

    print("▶ 1. DensifyPointCloud – zagęszcza chmurę punktów z SfM: STARTED")
    subprocess.run([
        "DensifyPointCloud",
        "scene.mvs",
        "--max-threads", "5"
    ])
    print("✔ 1. FINISHED")

    print("▶ 2. ReconstructMesh – buduje siatkę (mesh) na podstawie gęstej chmury punktów: STARTED")
    subprocess.run([
        "ReconstructMesh",
        "-i", "scene_dense.mvs",
        "--archive-type", "2"
    ])
    print("✔ 2. FINISHED")

    print("▶ 3. RefineMesh Popraw normalne jeśli mesh jest odwrócony: STARTED")
    subprocess.run([
        "RefineMesh",
        "-i", "scene_dense_mesh.mvs",
        "--ensure-edge-size", "2",
        "--close-holes", "0",
        "--decimate", "1",
        "-o", "scene_refined.mvs"
    ])
    print("✔ 3. FINISHED")

    print("▶ 4. TextureMesh – nakłada tekstury na siatkę (UV mapping + kolor): STARTED")
    subprocess.run([
        "TextureMesh",
        "scene_refined.mvs",
        "--archive-type", "2",
        "--export-type", "OBJ"
    ])
    print("✔ 4. FINISHED")

    print("✔ OpenMVS processing: FINISHED\n")


def start_blender_processing():
    print("▶ Blender processing: STARTED\n")

    print("▶ 1. Blender optimization started: STARTED")
    subprocess.run([
        "blender",
        "--background",
        "--python", "blender.py"
    ])
    print("✔ 1. FINISHED")

    print("✔ Blender processing: FINISHED\n")


def start_gltf_processing():
    print("▶ GLTF processing: STARTED\n")

    print("▶ 1. glTF draco started: STARTED")
    subprocess.run([
        "gltf-transform",
        "draco",
        "/app/workdir/product.glb",
        "/output/product_draco.glb"
    ])
    print("✔ 1. FINISHED")

    print("▶ 2. glTF optimization started: STARTED")
    subprocess.run([
        "gltf-transform",
        "optimize",
        "/output/product_draco.glb",
        "/output/product_final.glb"
        "--texture-compress", "webp",
        "--texture-size", "2048",
    ])
    print("✔ 2. FINISHED")

    print("✔ GLTF processing: FINISHED\n")


def start_processing():
    print("▶ PIPELINE STARTED ...\n")

    copy_images()
    start_open_mvg_processing()
    start_open_mvs_processing()
    start_blender_processing()
    start_gltf_processing()

    print("✔ PIPELINE DONE")


if __name__ == "__main__":
    start_processing()
