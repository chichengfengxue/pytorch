FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git wget && apt-get --fix-broken install -y

RUN conda install -y faiss-gpu scikit-learn pandas flake8 yapf isort yacs gdown future libgcc h5py=3.4.0 -c conda-forge

RUN pip install --upgrade pip && python -m pip install --upgrade setuptools==69.5.1

RUN pip install pycocotools matplotlib==3.8.4

RUN pip install openpifpaf --no-build-isolation

COPY ./fonts/* /opt/conda/lib/python3.10/site-packages/matplotlib/mpl-data/fonts/ttf/

RUN pip install git+https://github.com/VlSomers/prtreid

RUN pip install git+https://github.com/TrackingLaboratory/poseval@pbtrack

RUN pip install git+https://github.com/TrackingLaboratory/lap
    
RUN pip install git+https://github.com/VlSomers/bpbreid
    
RUN pip install \
    hydra-core==1.3 \
    lightning>=2.0 \
    pytorch_lightning==2.0 \
    numpy==1.23.5 \
    openmim==0.3.9 \
    ultralytics==8.0.61 \
    sphinx==7.2 \
    sphinx_rtd_theme==2.0 \
    myst-parser==2.0 \
    filterpy==1.4.5 \
    mmdet~=3.1.0 \
    chumpy==0.66

RUN pip install opencv-python tb-nightly logger_tt tabulate tqdm wheel mccabe scipy easyocr==1.7.1 soccernet==0.1.55 mmocr==1.0.1

RUN pip install \
    mmengine==0.10.1 \
    timm==0.9.12 \
    mmpose==1.2.0 \
    gdown==4.7.1 \
    pandas==2.1.0

RUN pip install yt-dlp>=2023.12.30 tabulate Pillow pytest

RUN mim install mmcv==2.0.1
