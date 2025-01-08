FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git && apt-get --fix-broken install -y

RUN pip install setuptools==60.2.0
RUN pip install -U openmim
RUN mim install mmcv-full==1.6.0
RUN pip install mmsegmentation==0.24.1

RUN pip install termcolor==2.5.0 yacs==0.1.8 tabulate==0.9.0 cloudpickle==3.1.0 tqdm==4.65.2 tensorboard==2.18.0 fvcore==0.1.5.post20221221
RUN pip install iopath==0.1.9 omegaconf==2.3.0 hydra-core==1.3.2 black==21.4b2 packaging==24.2 timm==1.0.12 scipy==1.13.1 shapely==2.0.6
RUN pip install Pygments==2.18.0 submitit==1.5.2 scikit-image==0.24.0
