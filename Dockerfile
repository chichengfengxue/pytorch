FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git && apt-get --fix-broken install -y

RUN pip install -U openmim
RUN mim install mmcv-full==1.6.0
RUN pip install mmsegmentation==0.24.1
RUN pip install shapely==2.0.6
RUN pip install pycocotools>=2.0.2 termcolor>=1.1 yacs>=0.1.8 cloudpickle tensorboard fvcore==0.1.5  iopath==0.1.9 omegaconf==2.3.0 hydra_core==1.3.2 black==24.8.0 antlr4-python3-runtime-4.9.3 portalocker mypy_extensions==1.0.0 pathspec==0.12.1 tensorboard_data_server==0.7.2 google_auth_oauthlib==1.0.0 grpcio==1.70.0 absl_py==2.1.0 google_auth==2.38.0 protobuf==5.29.3 werkzeug>=1.0.1 rsa==4.9 pyasn1-modules>=0.2.1 cachetools==5.5.2  requests-oauthlib>=0.7.0 pyasn1==0.6.1 oauthlib>=3.0.0 MarkupSafe>=2.1.1 MarkupSafe==2.1.5 appdirs pyquaternion coloredlogs typing humanfriendly>=9.1 cython scipy timm h5py submitit scikit-image huggingface_hub safetensors tifffile>=2022.8.12 imageio>=2.27 networkx>=2.8 PyWavelets>=1.1.1 lazy_loader>=0.2 fsspec>=2023.5.0
