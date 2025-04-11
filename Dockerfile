FROM pytorch/pytorch:1.7.1-cuda11.0-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git && apt-get --fix-broken install -y

RUN pip install jaxtyping==0.2.11
RUN pip install yapf==0.40.1
RUN pip install -U openmim
RUN pip install mmcv==1.2.7 -f https://download.openmmlab.com/mmcv/dist/cu110/torch1.7.0/index.html
RUN pip install tqdm
RUN pip install timm



