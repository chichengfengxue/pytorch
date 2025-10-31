FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-devel

RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git && apt-get --fix-broken install -y

RUN pip install ultralytics ultralytics-thop
RUN pip install numpy opencv-python opencv-python-headless Pillow matplotlib seaborn scikit-image
RUN pip install tqdm pyyaml pandas scipy scikit-learn psutil
RUN pip install imageio tifffile filelock packaging

RUN pip list
