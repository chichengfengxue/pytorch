FROM pytorch/pytorch:2.1.2-cuda11.8-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git && apt-get --fix-broken install -y

RUN pip install -U openmim
RUN pip install mmcv-full==1.7.2
RUN pip install natten==0.17.3+torch210cu121 -f https://shi-labs.com/natten/wheels/
