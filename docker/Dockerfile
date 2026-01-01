# ---------- 1. Base image: Blender headless ----------
FROM lscr.io/linuxserver/blender:latest

#FROM ubuntu:22.04

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
    python3-dev \
    python3-numpy \
    python3-pip \
    libtiff-dev \
    libgtk-3-dev \
    libopenexr-dev \
    libxi-dev \
    libxrandr-dev \
    libxinerama-dev \
    libwebp-dev \
    libxcursor-dev \
    curl \
#    libjxl-dev \
    pkg-config \
    graphviz \
    libcgal-dev \
    libcgal-qt5-dev \
    libeigen3-dev \
    libboost-all-dev \
    libgmp-dev \
    libmpfr-dev \
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

# ---------- 6. Install OpenCV 4.9+ with JPEG XL ----------
RUN mkdir -p /opt/opencv_build && cd /opt/opencv_build \
        && wget -O opencv.zip https://github.com/opencv/opencv/archive/refs/tags/4.12.0.zip \
        && unzip opencv.zip \
        && wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/refs/tags/4.12.0.zip \
        && unzip opencv_contrib.zip

# ---------- 2. Build libjxl from source ----------
RUN mkdir -p /opt/jxl_build && cd /opt/jxl_build \
    && wget -O libjxl.zip https://github.com/libjxl/libjxl/archive/refs/heads/main.zip \
    && unzip libjxl.zip \
    && cd libjxl-main \
    && ./deps.sh \
    && mkdir build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_TESTING=OFF -DJXL_ENABLE_TESTS=OFF -DJXL_ENABLE_TOOLS=OFF -DJXL_INSTALL_PKG_CONFIG=ON .. \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd / && rm -rf /opt/jxl_build

RUN mkdir -p /opt/opencv_build/opencv-4.12.0/build && cd /opt/opencv_build/opencv-4.12.0/build \
    && cmake -DCMAKE_BUILD_TYPE=RELEASE \
             -DCMAKE_INSTALL_PREFIX=/usr/local \
             -DCMAKE_PREFIX_PATH=/usr/local \
             -DOPENCV_EXTRA_MODULES_PATH=/opt/opencv_build/opencv_contrib-4.12.0/modules \
             -DBUILD_TESTS=OFF \
             -DBUILD_PERF_TESTS=OFF \
             -DBUILD_EXAMPLES=OFF \
             -DBUILD_DOCS=OFF \
             -DWITH_IPP=OFF \
             -DWITH_TBB=ON \
             -DWITH_OPENGL=ON \
             -DWITH_V4L=ON \
             -DWITH_LIBV4L=ON \
             -DWITH_GSTREAMER=ON \
             -DWITH_JPEG=ON \
             -DWITH_JPEGXL=ON \
             -DOPENCV_ENABLE_JPEGXL=ON \
             -DWITH_PNG=ON \
             -DWITH_WEBP=ON \
             -DWITH_TIFF=ON \
             -DPYTHON3_EXECUTABLE=$(which python3) \
             -DPYTHON3_INCLUDE_DIR=$(python3 -c "from sysconfig import get_paths as p; print(p()['include'])") \
             -DPYTHON3_PACKAGES_PATH=$(python3 -c "from sysconfig import get_paths as p; print(p()['purelib'])") \
             -DBUILD_opencv_python3=ON \
             .. \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd / \
    && rm -rf /opt/opencv_build

# ---------- 7. Install nanoflann ----------
RUN git clone https://github.com/jlblancoc/nanoflann.git /opt/nanoflann \
    && cd /opt/nanoflann \
    && mkdir build && cd build \
    && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
    && make install

# ---------- Build CGAL from source ----------
RUN mkdir -p /opt/cgal && cd /opt/cgal \
    && wget https://github.com/CGAL/cgal/releases/download/v6.1/CGAL-6.1.zip \
    && unzip CGAL-6.1.zip \
    && cd CGAL-6.1 \
    && cmake -DCMAKE_BUILD_TYPE=Release \
             -DCMAKE_INSTALL_PREFIX=/usr/local \
             . \
    && make install

## ---------- 8. Install OpenMVS develop ----------
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