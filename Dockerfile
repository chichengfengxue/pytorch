FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git && apt-get --fix-broken install -y

RUN conda install pytorch-cuda=11.6 xformers faiss-gpu ipykernel jupyter ffmpeg
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

RUN pip install -U openmim
RUN mim install mmcv-full==1.7.2
RUN pip install mmsegmentation==0.30.0
RUN pip install shapely==2.0.6
RUN pip install pycocotools>=2.0.2 termcolor>=1.1 yacs>=0.1.8 cloudpickle tensorboard fvcore  iopath omegaconf 
RUN pip install hydra_core black antlr4-python3-runtime portalocker mypy_extensions pathspec tensorboard_data_server
RUN pip install google_auth_oauthlib grpcio absl_py google_auth protobuf werkzeug>=1.0.1 rsa pyasn1-modules>=0.2.1 
RUN pip install cachetools  requests-oauthlib>=0.7.0 pyasn1 oauthlib>=3.0.0 MarkupSafe>=2.1.1 MarkupSafe appdirs pyquaternion coloredlogs 
RUN pip install typing humanfriendly>=9.1 cython scipy timm h5py submitit scikit-image huggingface_hub safetensors tifffile>=2022.8.12 imageio>=2.27 networkx>=2.8 
RUN pip install PyWavelets>=1.1.1 lazy_loader>=0.2 fsspec>=2023.5.0
RUN pip install jaxtyping==0.2.11 numpy==1.24.4 jinja2==2.11.3 transformers==4.40.2
