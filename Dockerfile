# 复现论文，地址：https://github.com/hoiliu-0801/DQ-DETR

# syntax=docker/dockerfile:1
FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
WORKDIR /workspace

# Install system dependencies and system Python (Ubuntu 22.04 provides python3)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake git wget ca-certificates tzdata locales \
    python3 python3-dev python3-pip python3-venv \
    libjpeg-dev libpng-dev pkg-config libatlas-base-dev \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && python -m pip install --upgrade pip setuptools wheel \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install core Python packages (PyTorch pinned to CUDA 12.4) and Cython
RUN pip install --no-cache-dir torch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 --index-url https://download.pytorch.org/whl/cu124 \
    && pip install --no-cache-dir cython==0.29.36 \
    && pip install --no-cache-dir "git+https://github.com/jwwangchn/cocoapi-aitod.git#subdirectory=aitodpycocotools"

# Copy repository source
COPY . /workspace

# Ensure CUDA path visible for building extensions
ENV CUDA_HOME=/usr/local/cuda
ENV TORCH_CUDA_ARCH_LIST="8.6;8.0;7.5"

# Build and install custom CUDA ops used by the project
RUN cd models/dqdetr/ops && python setup.py build install

# Default to an interactive shell; users can run training scripts from /workspace
ENTRYPOINT ["/bin/bash"]
