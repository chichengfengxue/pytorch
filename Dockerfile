FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git && apt-get --fix-broken install -y

RUN pip install shapely>=2.0.6
RUN pip install pycocotools>=2.0.2 termcolor>=1.1 yacs>=0.1.8 cloudpickle tensorboard fvcore  iopath omegaconf 
RUN pip install hydra_core black antlr4-python3-runtime portalocker mypy_extensions pathspec tensorboard_data_server
RUN pip install google_auth_oauthlib grpcio absl_py google_auth protobuf werkzeug>=1.0.1 rsa pyasn1-modules>=0.2.1 
RUN pip install cachetools  requests-oauthlib>=0.7.0 pyasn1 oauthlib>=3.0.0 MarkupSafe>=2.1.1 MarkupSafe appdirs pyquaternion coloredlogs 
RUN pip install typing humanfriendly>=9.1 cython scipy timm h5py submitit scikit-image huggingface_hub safetensors tifffile>=2022.8.12 imageio>=2.27 networkx>=2.8 
RUN pip install PyWavelets>=1.1.1 lazy_loader>=0.2 fsspec>=2023.5.0
RUN pip install jaxtyping==0.2.11 numpy==1.24.4 jinja2==2.11.3 transformers==4.40.2
RUN pip install triton>=3.3.1 sqlalchemy>=2.0.41
RUN pip install mmcv==2.0.0  mmengine  
RUN pip install \
    einops==0.8.1 \
    matplotlib==3.10.3 \
    rich==14.0.0 \
    timm \
    transformers==4.40.2 \
    tokenizers==0.19.1 \
    huggingface-hub==0.33.4 \
    safetensors==0.5.3 \
    setuptools==65.5.0 \
    ninja==1.11.1.4 \
    pyyaml==6.0 \
    tqdm==4.64.1 \
    opencv-python-headless \
    yacs \
    addict \
    packaging \
    simplejson \
    docopt
RUN pip install buildtools==1.0.6 argparse==1.4.0 twisted==25.5.0 simplejson==3.20.1 furl==2.1.4 docopt==0.6.2 redo==3.0.0 orderedmultidict==1.0.1 \
    attrs==25.3.0 automat==25.4.16 constantly==23.10.4 hyperlink==21.0.0 zope.interface==7.2 einops==0.8.1 terminaltables==3.1.10 prettytable==3.16.0
RUN pip uninstall numpy -y
RUN pip install mmdet ftfy ipdb numpy==1.24.4 
RUN pip uninstall cython -y
RUN pip install cython==0.29.33
