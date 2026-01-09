# 复现论文，地址 git clone https://github.com/dyl96/LTDNet

ARG PYTORCH="1.6.0"
ARG CUDA="10.1"
ARG CUDNN="7"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"

# 非交互模式：避免访问镜像中可能存在的 NVIDIA apt 源（导致 NO_PUBKEY），
# 先删除指向 developer.download.nvidia.com 的条目，替换为国内镜像后更新并安装包
ENV DEBIAN_FRONTEND=noninteractive
RUN if [ -d /etc/apt/sources.list.d ]; then sed -i '/developer.download.nvidia.com/d' /etc/apt/sources.list.d/* 2>/dev/null || true; fi \
 && sed -i.bak -E 's|http://(archive|security).ubuntu.com/ubuntu/|https://mirrors.tuna.tsinghua.edu.cn/ubuntu/|g' /etc/apt/sources.list \
 && apt-get update --allow-releaseinfo-change \
 && apt-get install -y --no-install-recommends ca-certificates curl \
 && apt-get install -y --no-install-recommends ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libxrender-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install MMCV
RUN pip install --no-cache-dir --upgrade pip wheel setuptools
RUN pip install --no-cache-dir mmcv-full==1.3.17 -f https://download.openmmlab.com/mmcv/dist/cu101/torch1.6.0/index.html

# Install MMDetection
RUN conda clean --all
RUN git clone https://github.com/open-mmlab/mmdetection.git /mmdetection
WORKDIR /mmdetection
ENV FORCE_CUDA="1"
RUN pip install --no-cache-dir -r requirements/build.txt
RUN pip install --no-cache-dir -e .
