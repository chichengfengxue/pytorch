# 复现论文，地址：https://github.com/hoiliu-0801/DQ-DETR

FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system packages and python3 (ubuntu22.04 ships python3.10)
RUN apt-get update \
   && apt-get install -y --no-install-recommends \
      python3 python3-dev python3-pip python3-distutils git build-essential cmake ca-certificates wget libsndfile1 \
   && ln -sf /usr/bin/python3 /usr/bin/python \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install build tools first
RUN python -m pip install --upgrade pip setuptools wheel \
   && python -m pip install --no-cache-dir numpy cython ninja

# Install PyTorch cu124 binaries from official index
RUN python -m pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cu124 \
      "torch==2.4.0+cu124" "torchvision==0.19.0+cu124" "torchaudio==2.4.0+cu124" || \
   (echo "PyTorch cu124 wheel install failed" && python -m pip debug --verbose && false)

WORKDIR /workspace

CMD ["/bin/bash"]





