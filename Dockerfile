FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git && apt-get --fix-broken install -y

RUN conda install -y faiss-gpu scikit-learn pandas flake8 yapf isort yacs gdown future libgcc h5py=3.4.0 -c conda-forge

RUN pip install --upgrade pip && python -m pip install --upgrade setuptools==58.0.4 && \
    pip install opencv-python tb-nightly logger_tt tabulate wheel mccabe kornia==0.6.3 pytorch-lightning==1.5.10 matplotlib==3.5.1 opencv-python-headless==4.5.5.62 jupyterlab==3.2.9 black numpy==1.19.5 pandas==1.4.1 pyyaml==6.0 scipy==1.8.0 seaborn==0.11.2 soccernet==0.1.34 tabulate==0.8.9 tqdm==4.62.3 ipyplot==1.1.1

COPY ./fonts/* /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/fonts/ttf/
