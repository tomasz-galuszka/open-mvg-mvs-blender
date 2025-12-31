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
    pkg-config \
    graphviz \
    libcgal-dev \
    libcgal-qt5-dev \
    libeigen3-dev \
    libboost-all-dev \
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

# ---------- 5. Install VCG ----------
RUN git clone https://github.com/cdcseacave/VCG.git /opt/VCG
ENV VCG_ROOT=/opt/VCG

RUN apt-get update && apt-get install -y \
    libjxl-dev \
    libjxl-tools \
    libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

# ---------- 6. Install OpenCV 4.9+ with JPEG XL ----------
RUN mkdir -p /opt/opencv_build && cd /opt/opencv_build \
    && wget -O opencv.zip https://github.com/opencv/opencv/archive/refs/tags/4.9.0.zip \
    && unzip opencv.zip \
    && wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/refs/tags/4.9.0.zip \
    && unzip opencv_contrib.zip \
    && mkdir -p opencv-4.9.0/build && cd opencv-4.9.0/build \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE \
             -D CMAKE_INSTALL_PREFIX=/usr/local \
             -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_build/opencv_contrib-4.9.0/modules \
             -D BUILD_EXAMPLES=OFF \
             -D BUILD_DOCS=OFF \
             -D BUILD_TESTS=OFF \
             -D BUILD_PERF_TESTS=OFF \
             -D WITH_IPP=OFF \
             -D WITH_TBB=ON \
             -D WITH_OPENGL=ON \
             -D WITH_V4L=ON \
             -D WITH_LIBV4L=ON \
             -D WITH_GSTREAMER=ON \
             -D WITH_JPEG=ON \
             -D WITH_JXL=ON \
             .. \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd / && rm -rf /opt/opencv_build

# ---------- 7. Install nanoflann ----------
RUN git clone https://github.com/jlblancoc/nanoflann.git /opt/nanoflann \
    && cd /opt/nanoflann \
    && mkdir build && cd build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && make install

# ---------- 8. Install OpenMVS develop ----------
RUN git clone --branch develop --recursive https://github.com/cdcseacave/OpenMVS.git /opt/OpenMVS \
    && mkdir /opt/OpenMVS/make \
    && cd /opt/OpenMVS/make \
    && cmake .. \
     -DCMAKE_BUILD_TYPE=RELEASE  \
     -DVCG_ROOT=$VCG_ROOT \
     -DCMAKE_INSTALL_PREFIX=/usr/local \
     -Dnanoflann_DIR=/usr/local/lib/cmake/nanoflann \
     -DOpenCV_DIR=/usr/local/lib/cmake/opencv4 \
    && cmake --build . -- -j1 \
    && cmake --install .

ENV PATH="/usr/local/bin/OpenMVS:$PATH"

# ---------- 9. Default working dir ----------
WORKDIR /app

# ---------- 10. Copy scripts ----------
COPY app .
RUN chmod +x /app/*.sh
RUN chmod +x /app/blender/*.sh
RUN chmod +x /app/gltf_transform/*.sh
RUN chmod +x /app/openmvg/*.sh
RUN chmod +x /app/openmvs/*.sh
RUN chmod +x /app/validation/*.sh
RUN chmod +x /app/workdir/*.sh

# ---------- 11. Default entrypoint ----------
ENTRYPOINT ["/bin/bash"]