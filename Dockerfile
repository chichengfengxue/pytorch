# 复现论文，地址 git clone https://github.com/dyl96/LTDNet

# Dockerfile
ARG PYTORCH="1.6.0"
ARG CUDA="10.1"
ARG CUDNN="7"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel-ubuntu20.04

# 推荐使用 keyring + signed-by 替代已弃用的 apt-key
RUN apt-get update && apt-get install -y --no-install-recommends \
        gnupg2 curl ca-certificates \
    && curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub | gpg --dearmor -o /usr/share/keyrings/nvidia-cuda-keyring.gpg \
    && curl -fsSL https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/7fa2af80.pub | gpg --dearmor -o /usr/share/keyrings/nvidia-ml-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/nvidia-cuda-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" > /etc/apt/sources.list.d/nvidia-cuda.list \
    && echo "deb [signed-by=/usr/share/keyrings/nvidia-ml-keyring.gpg] https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/ /" > /etc/apt/sources.list.d/nvidia-ml.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libxrender-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
# base image 提供 conda 在 /opt/conda
ENV CMAKE_PREFIX_PATH="/opt/conda"

# Install MMCV
RUN pip install --no-cache-dir --upgrade pip wheel setuptools
RUN pip install --no-cache-dir mmcv-full==1.3.17 -f https://download.openmmlab.com/mmcv/dist/cu101/torch1.6.0/index.html

# Install MMDetection
RUN /opt/conda/bin/conda clean --all -y || true
RUN git clone https://github.com/open-mmlab/mmdetection.git /mmdetection
WORKDIR /mmdetection
ENV FORCE_CUDA="1"
RUN pip install --no-cache-dir -r requirements/build.txt
RUN pip install --no-cache-dir -e .
