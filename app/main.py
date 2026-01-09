import subprocess

def module_versions():
    print("-- MODULES CHECK --")

    print("▶ Blender")
    subprocess.run(["blender", "--background", "--python-expr", "import bpy; print(bpy.app.version_string)"])

    print("▶ OpenMVG")
    subprocess.run(["whereis", "openMVG_main_SfMInit_ImageListing"])
    subprocess.run(["whereis", "openMVG_main_ComputeFeatures"])
    subprocess.run(["whereis", "openMVG_main_ComputeMatches"])
    subprocess.run(["whereis", "openMVG_main_SfM"])
    subprocess.run(["whereis", "openMVG_main_openMVG2openMVS"])

    print("▶ OpenMVS")
    subprocess.run(["whereis", "DensifyPointCloud"])
    subprocess.run(["whereis", "ReconstructMesh"])
    subprocess.run(["whereis", "RefineMesh"])
    subprocess.run(["whereis", "TextureMesh"])

    print("▶ CGAL")
    subprocess.run("dpkg -l | grep cgal", shell=True)

    print("▶ VCG linked with OpenMVS")
    subprocess.run("strings $(which ReconstructMesh) | grep -i vcg | head", shell=True)

    print("▶ EIGEN")
    subprocess.run("dpkg -l | grep eigen", shell=True)

    print("▶ NODE & NPM")
    subprocess.run(["node", "--version"])
    subprocess.run(["npm", "--version"])

    print("▶ GLTF-TRANSFORM")
    subprocess.run(["gltf-transform", "--version"])

    print("▶ Python3 & PIP3")
    subprocess.run(["python3", "--version"])
    subprocess.run(["pip3", "--version"])

    print("✅ ALL MODULES CHECKED")

if __name__ == "__main__":
    module_versions()
