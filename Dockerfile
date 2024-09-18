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
    xformers==0.0.22.post7 \
    opencv-python==4.8.1.78
    
RUN pip install antialiased_cnns einops imageio[ffmpeg] kornia mediapy pandas pillow tqdm PyYAML Cython nvidia-ml-py opencv-python ruamel.yaml==0.16.6 colorlog colorama tensorboard tensorboardx torch_tb_profiler 

RUN pip install snakeviz six blessed torchinfo

RUN pip install git+https://github.com/facebookresearch/detectron2
