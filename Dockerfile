# 复现论文，地址 git clone https://github.com/dyl96/LTDNet

# Dockerfile — Ubuntu 20.04 base, conda, PyTorch >=1.3, 保留 mmcv/mmcv-full 与 mmdetection 原文安装段
# 注意：
# - 本镜像基于 Ubuntu 20.04，CUDA 镜像选择由 ARG 控制（默认 11.3）。如果你确实需要 mmcv-full==1.3.17 对应的 cu101/torch1.6.0 预编译 wheel，
#   需要确保 base CUDA / PyTorch 与之匹配；当前文件保留原始 mmcv 安装行，但可能会触发从源码构建（若版本不匹配）。
# - 如果需要严格匹配 cu101 + torch1.6.0，请将 ARG CUDA 与安装的 pytorch 对应调整为合适版本（或使用官方 pytorch/pytorch:1.6.0-cuda10.1-* image）。
ARG CUDA="11.3.1"
ARG CUDNN="8"
ARG PYTHON_VERSION="3.9"
ARG CONDA_DIR="/opt/conda"

FROM nvidia/cuda:${CUDA}-cudnn${CUDNN}-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=${CONDA_DIR}/bin:${PATH}
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# 基本系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget ca-certificates bzip2 git build-essential cmake \
    ffmpeg libsm6 libxext6 libglib2.0-0 libxrender-dev \
    ninja-build pkg-config unzip curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 安装 Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p ${CONDA_DIR} && \
    rm /tmp/miniconda.sh && \
    ${CONDA_DIR}/bin/conda clean -afy

# 创建 conda 环境并安装 Python 与 PyTorch（可按需调整版本）
# 这里安装 PyTorch >=1.3（示例用 1.10.1 + cudatoolkit=11.3）以满足项目需求。
RUN conda create -n LTDNet python=${PYTHON_VERSION} -y && \
    /bin/bash -lc "conda activate LTDNet && \
    conda install -y -c pytorch -c conda-forge pytorch==1.10.1 torchvision==0.11.2 torchaudio==0.10.1 cudatoolkit=11.3 && \
    pip install --upgrade pip setuptools wheel && \
    conda clean -afy"

# 将 conda env 激活方式写入 PATH（运行时用 `conda run -n LTDNet ...` 或显式激活）
ENV CONDA_DEFAULT_ENV=LTDNet

# Install MMCV
RUN /bin/bash -lc "source ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate LTDNet && \
    pip install --no-cache-dir --upgrade pip wheel setuptools"
RUN /bin/bash -lc "source ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate LTDNet && \
    pip install --no-cache-dir mmcv-full==1.3.17 -f https://download.openmmlab.com/mmcv/dist/cu101/torch1.6.0/index.html"

# Install MMDetection
RUN /bin/bash -lc "source ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate LTDNet && conda clean --all"
RUN git clone https://github.com/open-mmlab/mmdetection.git /mmdetection
WORKDIR /mmdetection
ENV FORCE_CUDA="1"
RUN /bin/bash -lc "source ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate LTDNet && \
    pip install --no-cache-dir -r requirements/build.txt"
RUN /bin/bash -lc "source ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate LTDNet && \
    pip install --no-cache-dir -e ."

# 安装 cocoapi-aitod（示例，若你使用特定 fork/版本请替换）
RUN /bin/bash -lc "source ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate LTDNet && \
    pip install git+https://github.com/your-org/cocoapi-aitod.git || true"

