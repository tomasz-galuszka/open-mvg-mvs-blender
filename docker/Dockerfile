# ---------- 1. Base image ----------
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# ---------- 2. Install dependencies ----------
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    wget \
    curl \
    unzip \
    software-properties-common \
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
    && rm -rf /var/lib/apt/lists/*

# ---------- 2a. Install Node.js & npm ----------
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g @gltf-transform/cli

# ---------- 3. Install Blender CLI ----------
RUN wget https://download.blender.org/release/Blender3.6/blender-3.6.1-linux-x64.tar.xz \
    && tar -xf blender-3.6.1-linux-x64.tar.xz -C /opt/ \
    && rm blender-3.6.1-linux-x64.tar.xz

ENV PATH="/opt/blender-3.6.1-linux-x64:$PATH"

# Test Blender
RUN blender --version

# ---------- 4. Install OpenMVG ----------
RUN git clone --recursive https://github.com/openMVG/openMVG.git /opt/openMVG \
    && mkdir /opt/openMVG/build \
    && cd /opt/openMVG/build \
    && cmake .. -DCMAKE_BUILD_TYPE=Release \
    && make -j$(nproc)

ENV PATH="/opt/openMVG/build/Linux-x86_64-RELEASE/bin:$PATH"

# ---------- 5. Install OpenMVS ----------
RUN git clone --recursive https://github.com/cdcseacave/OpenMVS.git /opt/OpenMVS \
    && mkdir /opt/OpenMVS/build \
    && cd /opt/OpenMVS/build \
    && cmake .. -DCMAKE_BUILD_TYPE=Release \
    && make -j$(nproc)

ENV PATH="/opt/OpenMVS/build/bin:$PATH"

# ---------- 7. Set working directory ----------
WORKDIR /app

# ---------- 8. Copy scripts ----------
COPY ./app/* /app/

# ---------- 9. Default entrypoint ----------
# Można nadpisać komendą "docker run"
ENTRYPOINT ["/bin/bash"]
