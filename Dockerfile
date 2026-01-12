# 复现论文，地址 git clone https://github.com/dyl96/LTDNet

FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# 基本依赖
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		wget ca-certificates curl git bzip2 build-essential cmake \
		ffmpeg libsm6 libxext6 libxrender-dev libglib2.0-0 \
		software-properties-common apt-transport-https gnupg2 && \
	rm -rf /var/lib/apt/lists/*

# 安装 Miniconda 到 /opt/conda
ENV CONDA_DIR=/opt/conda
RUN set -eux; \
	for i in 1 2 3; do \
		wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && break || sleep 5; \
	done; \
	chmod +x /tmp/miniconda.sh; \
	bash /tmp/miniconda.sh -b -p "${CONDA_DIR}"; \
	rm -f /tmp/miniconda.sh; \
	"${CONDA_DIR}/bin/conda" clean -afy

ENV PATH=${CONDA_DIR}/bin:${PATH}

# 更新 conda、创建环境（可选改为创建独立 env）并安装 PyTorch 1.6.0 + cudatoolkit 10.1
RUN conda update -n base -c defaults conda -y && \
	conda install -y -c pytorch pytorch==1.6.0 cudatoolkit=10.1 && \
	conda clean -afy

# 设置常用环境变量
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"

# Python 包管理：升级 pip、wheel、setuptools
RUN pip install --no-cache-dir --upgrade pip wheel setuptools

# 安装 mmcv-full（使用 OpenMMLab 的 cu101 + torch1.6.0 轮子索引）
# 如果在构建中遇到二进制不匹配，可能需要修改或编译 mmcv-full
RUN pip --no-cache-dir install mmcv-full==1.3.17 -f https://download.openmmlab.com/mmcv/dist/cu101/torch1.6.0/index.html || true

# 安装 MMDetection（可选），并安装可选依赖（与原 Dockerfile 保持功能一致）
RUN git clone https://github.com/open-mmlab/mmdetection.git /mmdetection && \
	cd /mmdetection && \
	pip --no-cache-dir install -r requirements/build.txt || true && \
	pip --no-cache-dir install -e . || true

# 清理 apt 与 conda 缓存以减小镜像体积
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* || true
RUN conda clean -afy || true

# 工作目录
WORKDIR /mnt/csip-113/zlx/LTDNet
