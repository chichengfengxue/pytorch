FROM pytorch/pytorch:2.4.1-cuda11.8-cudnn9-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git ffmpeg && apt-get --fix-broken install -y
RUN pip install einops==0.8.0 matplotlib==3.7.0 numpy==1.24.4 timm==1.0.11 plotly tensorboard hydra-core ipykernel rich pytest scikit-learn torchmetrics==1.6.2 transformers
RUN pip install jaxtyping==0.3.3 wadler-lindig==0.1.7 rich==14.2.0 triton==3.0.0 jinja2==3.1.4 opencv-python-4.11.0.86

RUN pip list
