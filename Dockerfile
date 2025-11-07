# Dockerfile: 用于构建 MMDetection / RFLA 开发镜像的脚本
# 概要：
# - 基于官方 PyTorch 带 CUDA 的开发镜像（包含编译工具）
# - 安装系统依赖（例如 ffmpeg，用于视频处理）
# - 安装 prebuilt 的 mmcv-full（与指定 torch/cuda 匹配）
# - 克隆 MMDetection 源码并以可编辑模式安装（便于在容器中开发/调试）
# 注意事项：
# - ARG 仅在构建时可用，用户可以通过 docker build --build-arg PYTORCH=... 覆盖
# - mmcv-full 使用了 OpenMMlab 提供的预编译轮子，需与 Torch/CUDA 版本匹配

ARG PYTORCH="1.6.0"
ARG CUDA="10.1"
ARG CUDNN="7"

# 使用 pytorch 官方预构建镜像（devel 版包含编译工具），版本由上面的 ARG 控制
FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

# 指定编译/运行时的 CUDA 架构，以及 nvcc 的额外 flags
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
# 指定 conda 前缀给 CMake 查找依赖（有些包的安装脚本会使用该变量）
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"

# 安装系统依赖：
# - ffmpeg: 视频处理
# - libsm6/libxext6/libxrender-dev: 图像显示/渲染相关库（常见于 opencv GUI 或 matplotlib）
# - git: 用于克隆仓库
# - ninja-build: 用于更快的 C/C++ 构建（一些 pip 包可能使用）
RUN apt-get update && apt-get install -y ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装 mmcv-full（预编译轮子），版本通过 URL 指向的索引安装并且与 torch1.6.0+cu101 对应
# 如果需要其他 torch/cuda 版本，请调整 ARG 并安装对应的 mmcv 轮子
RUN pip install mmcv-full==latest+torch1.6.0+cu101 -f https://openmmlab.oss-accelerate.aliyuncs.com/mmcv/dist/index.html

# 清理 conda 缓存，以减少镜像体积
RUN conda clean --all

WORKDIR /mnt/csip-113/zlx

# 克隆 mmdetection 源码到容器中（放到 /mmdetection），并切换到该目录
RUN git clone https://github.com/open-mmlab/mmdetection.git /mmdetection
WORKDIR /mnt/csip-113/zlx/mmdetection

# 一些安装脚本会检测该环境变量以决定是否启用 CUDA
ENV FORCE_CUDA="1"

# 安装构建时依赖（requirements/build.txt），然后以可编辑模式安装当前仓库
# RUN pip install -r requirements/build.txt
RUN pip install python
RUN pip install numpy

RUN pip install --no-cache-dir -e .
