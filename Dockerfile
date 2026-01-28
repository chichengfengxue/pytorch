# 复现论文，地址：https://github.com/hoiliu-0801/DQ-DETR

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

# Build args: allow skipping torch install during multi-arch build or CI
ARG TARGETARCH
ARG INSTALL_TORCH=1

# Install PyTorch only when requested; install Cython and cocoapi-aitod always
RUN if [ "${INSTALL_TORCH}" = "1" ]; then \
            if [ "${TARGETARCH}" = "amd64" ] || [ -z "${TARGETARCH}" ]; then \
                pip install --no-cache-dir torch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 --index-url https://download.pytorch.org/whl/cu124 ; \
            else \
                pip install --no-cache-dir torch==2.4.0+cpu torchvision==0.19.0+cpu --extra-index-url https://download.pytorch.org/whl/cpu ; \
            fi ; \
        else \
            echo "Skipping PyTorch install (INSTALL_TORCH=${INSTALL_TORCH})" ; \
        fi && \
        pip install --no-cache-dir cython==0.29.36 && \
        pip install --no-cache-dir "git+https://github.com/jwwangchn/cocoapi-aitod.git#subdirectory=aitodpycocotools"

# Note: source copying and CUDA-extension compilation are intentionally omitted.
# Mount the repository into the container at runtime to build or run as needed.
