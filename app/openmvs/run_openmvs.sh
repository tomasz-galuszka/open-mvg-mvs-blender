echo -e "# OpenMVS STARTED"

DensifyPointCloud openmvs/scene.mvs
ReconstructMesh openmvs/scene_dense.mvs
TextureMesh openmvs/scene_dense_mesh.mvs


echo -e "# OpenMVS FINISHED\n"