# 复现论文，地址 git clone https://github.com/dyl96/LTDNet

ARG PYTORCH="1.6.0"
ARG CUDA="10.1"
ARG CUDNN="7"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"

# 非交互模式，使用国内镜像并确保 NVIDIA apt 仓库公钥可用，合并为一个 RUN 步骤以减少镜像层
ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i.bak -E 's|http://(archive|security).ubuntu.com/ubuntu/|https://mirrors.tuna.tsinghua.edu.cn/ubuntu/|g' /etc/apt/sources.list \
 && apt-get update || true \
 && apt-get install -y --no-install-recommends ca-certificates gnupg2 curl \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC || true \
 && apt-get update --allow-releaseinfo-change \
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
