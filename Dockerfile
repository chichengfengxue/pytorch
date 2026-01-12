# 复现论文，地址 git clone https://github.com/dyl96/LTDNet

FROM ubuntu:20.04

# Avoid interactive prompts during build
ARG DEBIAN_FRONTEND=noninteractive

# Optional: switch Ubuntu apt mirror (default: Tsinghua)
ARG UBUNTU_MIRROR_HOST=mirrors.tuna.tsinghua.edu.cn

# CUDA / cuDNN versions (requested)
ARG CUDA_VERSION=10.1
ARG CUDA_PATCH=243
ARG CUDA_RUNFILE=cuda_${CUDA_VERSION}.${CUDA_PATCH}_418.87.00_linux.run
ARG CUDA_RUNFILE_URL=https://developer.download.nvidia.com/compute/cuda/${CUDA_VERSION}/Prod/local_installers/${CUDA_RUNFILE}

# IMPORTANT:
# - cuDNN tarball must be provided manually in build context as "cudnn.tgz"
# - It should be the cuDNN v7 package for CUDA 10.1, typically named like:
#   cudnn-10.1-linux-x64-v7.x.x.x.tgz

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux; \
	sed -i "s|http://archive.ubuntu.com/ubuntu/|http://${UBUNTU_MIRROR_HOST}/ubuntu/|g" /etc/apt/sources.list; \
	sed -i "s|http://security.ubuntu.com/ubuntu/|http://${UBUNTU_MIRROR_HOST}/ubuntu/|g" /etc/apt/sources.list; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
	  ca-certificates \
	  curl \
	  git \
	  gnupg \
	  libglib2.0-0 \
	  libgl1 \
	  libstdc++6 \
	  libxext6 \
	  libxrender1 \
	  python3 \
	  python3-dev \
	  python3-pip \
	  python3-setuptools \
	  python3-wheel \
	  unzip \
	  wget; \
	rm -rf /var/lib/apt/lists/*

# ---- Install CUDA Toolkit 10.1 (manual runfile install; DO NOT install driver) ----
RUN set -eux; \
	mkdir -p /tmp/cuda; \
	wget -q "${CUDA_RUNFILE_URL}" -O /tmp/cuda/cuda.run; \
	sh /tmp/cuda/cuda.run --silent --toolkit --override --installpath=/usr/local/cuda-10.1; \
	rm -rf /tmp/cuda

ENV CUDA_HOME=/usr/local/cuda-10.1
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}

# ---- Install cuDNN v7 manually (provide cudnn.tgz in build context) ----
COPY cudnn.tgz /tmp/cudnn.tgz
RUN set -eux; \
	tar -xzf /tmp/cudnn.tgz -C /tmp; \
	cp -a /tmp/cuda/include/cudnn*.h ${CUDA_HOME}/include/; \
	cp -a /tmp/cuda/lib64/libcudnn* ${CUDA_HOME}/lib64/; \
	chmod a+r ${CUDA_HOME}/include/cudnn*.h ${CUDA_HOME}/lib64/libcudnn*; \
	rm -rf /tmp/cudnn.tgz /tmp/cuda; \
	ldconfig

# ---- Install PyTorch 1.6.0 (CUDA 10.1 wheels) ----
RUN set -eux; \
	python3 -m pip install --upgrade pip; \
	python3 -m pip install --no-cache-dir \
	  "torch==1.6.0+cu101" \
	  "torchvision==0.7.0+cu101" \
	  -f https://download.pytorch.org/whl/torch_stable.html

# Basic sanity check (doesn't require a GPU at build time)
RUN python3 - <<'PY'
import torch
print('torch:', torch.__version__)
print('cuda available:', torch.cuda.is_available())
print('cuda version:', torch.version.cuda)
PY


# 工作目录
WORKDIR /mnt/csip-113/zlx/LTDNet
