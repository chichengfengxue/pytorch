FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git ffmpeg && apt-get --fix-broken install -y
RUN pip install --no-cache-dir xformers==0.0.16 --index-url https://download.pytorch.org/whl/cu116
RUN pip install faiss-gpu
RUN pip install ipykernel jupyter 
RUN pip install --no-cache-dir \
    absl-py \
    accelerate \
    addict \
    aiohttp \
    aliyun-python-sdk-core \
    aliyun-python-sdk-kms \
    antlr4-python3-runtime \
    clip \
    colorama \
    contourpy \
    crcmod \
    cryptography \
    einops \
    filelock \
    fonttools \
    fsspec \
    ftfy \
    grpcio \
    h5py \
    huggingface-hub \
    hydra-core \
    imageio \
    ipdb \
    jinja2 \
    joblib \
    kiwisolver \
    kornia \
    kornia-rs \
    lightning-utilities \
    markdown \
    markdown-it-py \
    matplotlib-inline \
    mdurl \
    mmcv-full \
    model-index \
    networkx \
    omegaconf \
    open-clip-torch \
    opendatalab \
    openmim \
    openxlab \
    ordered-set \
    oss2 \
    peft \
    pillow \
    protobuf \
    psutil \
    pycocotools \
    pycryptodome \
    pyparsing \
    pytorch-lightning \
    pyyaml \
    regex \
    requests \
    rich \
    safetensors \
    scikit-image \
    scikit-learn \
    stack-data \
    tabulate \
    tensorboard \
    timm \
    tokenizers \
    torch-tb-profiler \
    torchmetrics \
    tqdm \
    transformers \
    triton \
    werkzeug \
    yapf
