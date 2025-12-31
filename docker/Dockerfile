# ---------- 1. Base image: Blender headless ----------
FROM lscr.io/linuxserver/blender:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
WORKDIR /app

# ---------- 2. Install dependencies ----------
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    wget \
    unzip \
    python3 \
    python3-pip \
    libopencv-dev \
    libboost-all-dev \
    libglew-dev \
    libeigen3-dev \
    libtbb-dev \
    libpng-dev \
    libjpeg-dev \
    libopenexr-dev \
    libxi-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxcursor-dev \
    curl \
    libjxl-dev \
    && rm -rf /var/lib/apt/lists/*

# ---------- 3. Install Node.js & glTF-Transform ----------
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g @gltf-transform/cli

# ---------- 4. Install OpenMVG ----------
RUN git clone --branch master --recursive https://github.com/openMVG/openMVG.git /opt/openMVG \
    && mkdir /opt/openMVG/build \
    && cd /opt/openMVG/build \
    && cmake -DCMAKE_BUILD_TYPE=RELEASE ../src/ \
    && make -j1

ENV PATH="/opt/openMVG/build/Linux-aarch64-RELEASE:$PATH"

# Install CGAL and dependencies (headless OpenMVS)
RUN apt-get update && apt-get install -y \
    libcgal-dev \
    libcgal-qt5-dev \
    libeigen3-dev \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# Install VCG and dependencies (headless OpenMVS)
RUN git clone https://github.com/cdcseacave/VCG.git /opt/VCG
ENV VCG_ROOT=/opt/VCG

# neato dependency for OpenMVG
RUN apt-get update && apt-get install -y graphviz

# Install VCG and dependencies (headless OpenMVS)
RUN git clone https://github.com/jlblancoc/nanoflann.git /opt/nanoflann \
    && cd /opt/nanoflann \
    && mkdir build && cd build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && make install

# ---------- 5. Install OpenMVS ----------
RUN git clone --branch develop --recursive https://github.com/cdcseacave/OpenMVS.git /opt/OpenMVS \
    && mkdir /opt/OpenMVS/make \
    && cd /opt/OpenMVS/make \
    && cmake .. \
     -DCMAKE_BUILD_TYPE=RELEASE  \
     -DVCG_ROOT=$VCG_ROOT \
     -DCMAKE_INSTALL_PREFIX=/usr/local \
      -Dnanoflann_DIR=/usr/local/lib/cmake/nanoflann \
    && cmake --build . -- -j1 \
    && cmake --install .

ENV PATH="/usr/local/bin/OpenMVS:$PATH"

# ---------- 7. Default working dir ----------
WORKDIR /app

# ---------- 6. Copy scripts ----------
COPY app .
RUN chmod +x /app/*.sh
RUN chmod +x /app/blender/*.sh
RUN chmod +x /app/gltf_transform/*.sh
RUN chmod +x /app/openmvg/*.sh
RUN chmod +x /app/openmvs/*.sh
RUN chmod +x /app/validation/*.sh
RUN chmod +x /app/workdir/*.sh

# ---------- 8. Default entrypoint ----------
# Można nadpisać komendą docker run
ENTRYPOINT ["/bin/bash"]
