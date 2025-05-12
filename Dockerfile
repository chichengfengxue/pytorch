FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git && apt-get --fix-broken install -y

RUN export CUDAHOME="/usr/local/cuda"
RUN export MKL_INTERFACE_LAYER=LP64
RUN conda create -y --name bevnet python=3.8 pip
RUN /bin/bash -c "source activate bevnet && pip install colorama"
