FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git wget && apt-get --fix-broken install -y

RUN conda install -y faiss-gpu scikit-learn pandas flake8 yapf isort yacs gdown future libgcc h5py -c conda-forge

RUN pip install --upgrade pip && python -m pip install --upgrade setuptools

RUN pip install pycocotools matplotlib numpy

COPY ./fonts/* /opt/conda/lib/python3.10/site-packages/matplotlib/mpl-data/fonts/ttf/
    
RUN pip install \
    ffmpeg-python \
    Flask \
    Flask_Cors \
    gradio>=3.7.0 \
    numpy==1.23.5 \
    pyworld \
    scipy==1.10.0 \
    SoundFile==0.12.1 \
    torchaudio \
    torchcrepe \
    tqdm \
    rich \
    loguru \
    scikit-maad \
    praat-parselmouth \
    onnx \
    onnxsim \
    onnxoptimizer \
    fairseq==0.12.2 \
    librosa==0.9.1 \
    tensorboard \
    tensorboardX \
    transformers \
    edge_tts \
    langdetect \
    pyyaml \
    pynvml \
    faiss-cpu \
    einops \
    local_attention \
