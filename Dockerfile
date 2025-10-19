FROM pytorch/pytorch:2.4.1-cuda11.8-cudnn9-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git ffmpeg && apt-get --fix-broken install -y
RUN pip install uv
RUN uv pip install einops 
RUN uv pip install matplotlib==3.7.0 
RUN uv pip install numpy==1.24.4 
RUN uv pip install timm==1.0.11 
RUN uv pip install plotly 
RUN uv pip install tensorboard 
RUN uv pip install hydra-core 
RUN uv pip install ipykernel 
RUN uv pip install rich 
RUN uv pip install pytest 
RUN uv pip install scikit-learn 
RUN uv pip install torchmetrics==1.6.2 
RUN uv pip install transformers

RUN pip list
