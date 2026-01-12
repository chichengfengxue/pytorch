# 复现论文，地址 git clone https://github.com/dyl96/LTDNet

# Dockerfile
ARG PYTORCH="1.6.0"
ARG CUDA="10.1"
ARG CUDNN="7"

FROM nvidia/cuda:${CUDA}-cudnn${CUDNN}-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive \
    CONDA_DIR=/opt/conda \
    TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX" \
    TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    FORCE_CUDA="1" \
    PATH=/opt/conda/bin:/usr/local/cuda/bin:$PATH

# 基本依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget ca-certificates git build-essential cmake curl \
    ffmpeg libsm6 libxext6 libxrender-dev libglib2.0-0 \
    ninja-build libsndfile1 && \
    rm -rf /var/lib/apt/lists/*

# 安装 Miniconda
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    $CONDA_DIR/bin/conda clean -afy

# 通过 conda 安装与 CUDA10.1 配套的 PyTorch 1.6.0（保留 CUDA/cuDNN 版本兼容性）
RUN conda install -y -c pytorch pytorch=${PYTORCH} torchvision=0.7.0 cudatoolkit=10.1 && \
    conda clean -afy

ENV CMAKE_PREFIX_PATH=$CONDA_DIR

# Python 包与 MMCV
RUN pip install --no-cache-dir --upgrade pip wheel setuptools
RUN pip install --no-cache-dir mmcv-full==1.3.17 -f https://download.openmmlab.com/mmcv/dist/cu101/torch1.6.0/index.html

# 安装 MMDetection（或其他仓库）
RUN git clone https://github.com/open-mmlab/mmdetection.git /mmdetection
WORKDIR /mmdetection
RUN pip install --no-cache-dir -r requirements/build.txt
RUN pip install --no-cache-dir -e .

# 清理（可选）
RUN conda clean -afy && rm -rf /var/lib/apt/lists/*
