FROM pytorch/pytorch:1.3-cuda10.1-cudnn7-devel
    
RUN apt-get update && apt-get install -y libgl1-mesa-glx libpci-dev curl nano psmisc zip git ffmpeg && apt-get --fix-broken install -y

RUN pip install mmcv==2.0.0rc4 -f https://download.openmmlab.com/mmcv/dist/index.html
RUN pip install "git+https://github.com/jwwangchn/cocoapi-aitod.git#subdirectory=aitodpycocotools"

RUN pip list
