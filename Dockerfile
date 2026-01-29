# 复现论文，地址：https://github.com/hoiliu-0801/DQ-DETR

FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ARG PYTHON_VERSION=3.9

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python${PYTHON_VERSION} python${PYTHON_VERSION}-dev python3-pip git build-essential cmake ca-certificates wget \
    && ln -sf /usr/bin/python${PYTHON_VERSION} /usr/bin/python \
    && python -m pip install --upgrade pip setuptools wheel \
    && python -m pip install numpy cython ninja \
    && python -m pip install --index-url https://download.pytorch.org/whl/cu124 \
       torch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


