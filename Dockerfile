# 复现论文，地址 git clone https://github.com/dyl96/LTDNet
# v2.3.3 尝试使用更高版本的torch和cuda，如果可以跑通最好

ARG BASE_IMAGE=nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04
FROM ${BASE_IMAGE}

ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHON_VERSION=3.8
ARG GCC_VERSION=9
ARG PYTORCH_VERSION=1.8.1+cu111
ARG TORCHVISION_VERSION=0.9.1+cu111
ARG MMCV_FULL=1
ARG COCOAPI_REPO=""

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
WORKDIR /workspace

# Install system dependencies and Python
RUN apt-get update && apt-get install -y --no-install-recommends \
		build-essential \
		git wget ca-certificates curl \
		python3 python3-dev python3-venv python3-pip python3-setuptools \
		libjpeg-dev zlib1g-dev libpng-dev \
		ffmpeg libsm6 libxext6 \
		&& rm -rf /var/lib/apt/lists/*

# Make `python` point to python3 and upgrade pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 || true \
		&& python -m pip install -U pip setuptools wheel

# Install PyTorch (>=1.3) -- choose a CUDA-enabled wheel matching the base image
RUN pip install --no-cache-dir \
		torch==${PYTORCH_VERSION} torchvision==${TORCHVISION_VERSION} -f https://download.pytorch.org/whl/torch_stable.html || \
		pip install --no-cache-dir torch torchvision

# Install MMCV (try mmcv-full for GPU support, fallback to mmcv)
RUN if [ "${MMCV_FULL}" = "1" ]; then \
			pip install --no-cache-dir mmcv-full -f https://download.openmmlab.com/mmcv/dist/cu111/torch1.8.0/index.html || pip install --no-cache-dir mmcv; \
		else \
			pip install --no-cache-dir mmcv; \
		fi

# Optionally clone and install cocoapi-aitod if a repo URL is provided at build time
RUN if [ -n "${COCOAPI_REPO}" ]; then \
			git clone ${COCOAPI_REPO} /workspace/cocoapi && \
			if [ -d /workspace/cocoapi/PythonAPI ]; then \
				cd /workspace/cocoapi/PythonAPI && python setup.py build_ext --inplace && pip install -e . ; \
			elif [ -f /workspace/cocoapi/setup.py ]; then \
				cd /workspace/cocoapi && python setup.py build_ext --inplace && pip install -e . ; \
			fi ; \
		fi

# Clean up apt caches
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

ARG PYTHONPATH=""
ENV PYTHONPATH=/workspace:${PYTHONPATH}

WORKDIR /mnt/csip-113/zlx/LTDNet

# Usage examples:
# Build with default args (CUDA 11.1 base image):
# docker build -t my-image:latest .
# Provide a cocoapi-aitod repo to build/install it during image build:
# docker build --build-arg COCOAPI_REPO=https://github.com/your/repo.git -t my-image:latest .

