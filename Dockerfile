FROM pytorch/pytorch:1.9.1-cuda11.1-cudnn8-devel

RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git && apt-get --fix-broken install -y

RUN conda install -y faiss-gpu scikit-learn pandas flake8 yapf isort yacs gdown future libgcc h5py=3.4.0 -c conda-forge

RUN pip install --upgrade pip && python -m pip install --upgrade setuptools && \
    pip install opencv-python tb-nightly matplotlib logger_tt tabulate tqdm wheel mccabe scipy=1.7.1 pillow=8.3.1 imageio=2.9.0 nni=3.0 mmcv=1.7.1

COPY ./fonts/* /opt/conda/lib/python3.8/site-packages/matplotlib/mpl-data/fonts/ttf/
