# 复现论文，地址：https://github.com/Qinrong-NKU/RUE

# 指定 PyTorch、CUDA、CuDNN 版本（用于选择基础镜像）
ARG PYTORCH="1.6.0"
ARG CUDA="10.1"
ARG CUDNN="7"

# 使用包含指定版本的 PyTorch CUDA 开发镜像（带编译工具链）
FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

# 配置构建出的 CUDA 内核支持的 GPU 架构；+PTX 便于兼容未来驱动
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX"
# 压缩 fatbin 以减小二进制体积
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
# 让 CMake 能找到 Conda 的前缀路径（用于依赖查找）
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"

# 安装系统与构建依赖；图形库用于部分可视化/图像操作
RUN apt-get update && apt-get install -y git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install mmsegmentation
# 清理 Conda 缓存，减少镜像体积
RUN conda clean --all

# 安装与当前 Torch/CUDA 匹配的 mmcv-full 二进制包
RUN pip install mmcv-full==latest+torch1.6.0+cu101 -f https://download.openmmlab.com/mmcv/dist/index.html
# 拉取 mmsegmentation 源码到容器内指定目录
RUN git clone https://github.com/open-mmlab/mmsegmentation.git /mmsegmentation
# 切换工作目录到项目根
WORKDIR /mmsegmentation
# 安装项目依赖
RUN pip install -r requirements.txt
# 以可编辑模式安装项目，便于源码改动即时生效
RUN pip install --no-cache-dir -e .
