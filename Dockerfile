FROM pytorch/pytorch:1.10.0-cuda11.3-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git && apt-get --fix-broken install -y

RUN pip install setuptools==75.1.0
RUN pip install jaxtyping==0.2.11
RUN pip install yapf==0.40.1
RUN pip install -U openmim
RUN pip install mmcv==1.3 -f https://download.openmmlab.com/mmcv/dist/cu113/torch1.10.0/index.html
RUN pip install mmsegmentation==0.13
RUN pip install tqdm==4.66.5 typing_extensions==4.12.2 transformers==4.46.3


