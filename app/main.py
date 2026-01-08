import subprocess

def print_versions():
    print("-- MODULES CHECK --")
    # subprocess.run(["ls", "-l"]) # executes a command and waits for it to finish,

    print("▶ Blender")
    # subprocess.run(["blender", "--background", "--python-expr", "import bpy; print(bpy.app.version_string)"])

    print("▶ OpenMVG")

    print("▶ OpenMVS")

    print("▶ CGAL")

    print("▶ VCG linked with OpenMVS")

    print("▶ EIGEN")

    print("▶ NODE & NPM")
    subprocess.run(["node", "--version"])
    subprocess.run(["npm", "--version"])

    print("▶ GLTF-TRANSFORM")

    print("▶ Python3 & PIP3")
    subprocess.run(["python3", "--version"])
    subprocess.run(["pip3", "--version"])

    print("✅ ALL MODULES CHECKED")

if __name__ == "__main__":
    print_versions()
