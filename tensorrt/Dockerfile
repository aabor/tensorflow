# aabor/tensorflow
# configured for automatic build
# https://github.com/jupyter/docker-stacks
FROM aabor/tensorrt-base:1.0.0

LABEL maintainer="A. A. Borochkin"

# https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ENV TZ=Europe/Kieve
ENV DEBIAN_FRONTEND=noninteractive

# https://github.com/jupyter/docker-stacks/tree/master/base-notebook
# https://hub.docker.com/r/jupyter/base-notebook
# docker pull jupyter/base-notebook
#
# Find other jupyter images
# https://hub.docker.com/u/jupyter
#
# This variables are set in base-notebook
# ARG NB_USER="jovyan"
# ARG NB_UID="1000"
# ARG NB_GID="100"

USER root

RUN apt update && apt install -y \
    ssh \
    cifs-utils \
    vim \
    xclip \
    curl \
    wget \
    jq \
    xz-utils \
    zlib1g \
    dpkg-sig \
    git \
    && sudo apt clean

RUN apt update && apt install -y \
    build-essential bison flex \
    software-properties-common \
    cmake \
    && sudo apt-get clean

# Install Node.js and npm for JupyterLab extensions
# Download and execute the NodeSource installation script
RUN curl -sL https://deb.nodesource.com/setup_16.x  | bash -
# The nodejs package contains both the node and npm binaries
RUN apt-get -y install nodejs

ARG USE_BAZEL_VERSION=5.1.1
RUN npm install -g @bazel/bazelisk

# see compatible versions for CUDA, cuDNN, cuBLAS, Apex, NVidia TensorRT, Torch-TensorRT
# https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_22-04.html#rel_22-04

# find installation instructions for required cuda version
# https://developer.nvidia.com/cuda-toolkit-archive
WORKDIR /tmp
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
RUN mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN wget https://developer.download.nvidia.com/compute/cuda/11.3.0/local_installers/cuda-repo-ubuntu2004-11-3-local_11.3.0-465.19.01-1_amd64.deb
RUN dpkg -i cuda-repo-ubuntu2004-11-3-local_11.3.0-465.19.01-1_amd64.deb
RUN apt-key add /var/cuda-repo-ubuntu2004-11-3-local/7fa2af80.pub
RUN apt-get update && apt-get -y install cuda


# https://developer.nvidia.com/blog/updating-the-cuda-linux-gpg-repository-key/
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
RUN dpkg -i cuda-keyring_1.0-1_all.deb

# https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-824/install-guide/index.html
# check available repos: https://developer.download.nvidia.com/compute/cuda/repos/
ARG OS=ubuntu2004
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/${OS}/x86_64/cuda-${OS}.pin 
RUN mv cuda-${OS}.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/${OS}/x86_64/7fa2af80.pub
RUN add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/${OS}/x86_64/ /"
RUN apt-get update
ARG cuda_version=cuda11.4
# https://pkgs.org/download/libcudnn8
ARG cudnn_version=8.2.4.15
RUN apt-get install libcudnn8=${cudnn_version}-1+${cuda_version}
RUN apt-get install libcudnn8-dev=${cudnn_version}-1+${cuda_version}

# TensorRT
# https://github.com/NVIDIA/Torch-TensorRT/releases
# https://docs.nvidia.com/deeplearning/tensorrt/install-guide/index.html#maclearn-net-repo-install
# https://pkgs.org/download/libnvinfer8
ARG tensorrt_version="8.2.4-1+cuda11.4"
RUN apt-get update && apt-get install \
  libnvinfer8=${tensorrt_version} \
  libnvonnxparsers8=${tensorrt_version} \
  libnvparsers8=${tensorrt_version} \
  libnvinfer-plugin8=${tensorrt_version} \
  libnvinfer-dev=${tensorrt_version} \
  libnvonnxparsers-dev=${tensorrt_version} \
  libnvparsers-dev=${tensorrt_version} \
  libnvinfer-plugin-dev=${tensorrt_version} \
  python3-libnvinfer=${tensorrt_version}
RUN apt-mark hold libnvinfer8 libnvonnxparsers8 libnvparsers8 libnvinfer-plugin8 libnvinfer-dev libnvonnxparsers-dev libnvparsers-dev libnvinfer-plugin-dev python3-libnvinfer

RUN apt-get update && apt-get install -y --no-install-recommends \
    qpdf \
    ghostscript \
    && apt-get clean

# RUN apt list -a qpdf
# RUN apt list -a ghostscript

RUN apt-get update && apt-get install -y --no-install-recommends \
    graphviz \
    libgraphviz-dev \
    pkg-config \
    && apt-get clean

# need for nbconvert
RUN apt-get update && apt-get install -y \
  pandoc \
  texlive-xetex texlive-fonts-recommended texlive-plain-generic

# install pyton packages as normal user 'jovyan'
USER ${NB_UID}

RUN pip install -U setuptools pip

RUN pip install --upgrade jupyterlab jupyterlab-git

# JupyterLab extentions
RUN pip install jupyterlab-theme-solarized-dark
# https://jupyterlab-code-formatter.readthedocs.io/en/latest/installation.html#prerequisites
# “Settings” > “Advanced Settings Editor” > “Jupyterlab Code Formatter”
RUN pip install jupyterlab_code_formatter
RUN pip install black isort autopep8

# https://github.com/jacobtomlinson/jupyterlab-nvdashboard
RUN pip install jupyter_bokeh
RUN pip install jupyterlab-bokeh-server
RUN pip install jupyterlab-nvdashboard

# https://ipywidgets.readthedocs.io/en/latest/user_install.html
RUN pip install ipywidgets jupyterlab_widgets

# https://github.com/jtpio/jupyterlab-system-monitor
RUN pip install jupyterlab-system-monitor
# https://github.com/chaoleili/jupyterlab_tensorboard

# https://github.com/jupyter-lsp/jupyterlab-lsp
# to use autocompletion disable Jedi:
# temporary %config Completer.use_jedi = False
# or permanently by setting c.Completer.use_jedi = False in your ipython_config.py file. 
RUN pip install 'python-lsp-server[all]'

# https://github.com/jupyterlab/jupyterlab-git

# https://github.com/jupyterlab/jupyterlab-latex
RUN pip install jupyterlab_latex

# https://pypi.org/project/jupyterlab-theme-solarized-dark/
# apply theme by checking Settings -> Jupyterlab Theme -> Jupyterlab Solarized Dark
# enable theme scrollbars Settings -> Jupyterlab Theme -> Theme Scrollbars

RUN jupyter labextension install \
  jupyterlab-topbar-extension

# https://jupyterlab.readthedocs.io/en/stable/user/debugger.html
# RUN mamba install xeus-python notebook -c conda-forge

RUN jupyter labextension list

# Torch
# https://pytorch.org/get-started/locally/
RUN pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113

# Torch-TensorRT
# https://nvidia.github.io/Torch-TensorRT/v1.0.0/tutorials/installation.html
RUN pip3 install torch-tensorrt -f https://github.com/NVIDIA/Torch-TensorRT/releases

RUN pip install nvidia-pyindex
RUN pip install onnx-graphsurgeon

# APEX
RUN git clone https://github.com/NVIDIA/apex
WORKDIR /tmp/apex
RUN pip3 install -v --disable-pip-version-check --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./

# Hugging Face Transformers
RUN pip install git+https://github.com/huggingface/transformers

RUN python3 -m pip install --user pyo

USER root
RUN apt-get update && apt-get install -y libsndfile1 ffmpeg
USER ${NB_UID}
RUN pip install Cython
RUN python -m pip install git+https://github.com/NVIDIA/NeMo.git@main#egg=nemo_toolkit[all]

# ADD requirements.txt /opt/
# RUN python -m pip install -r /opt/requirements.txt --no-cache-dir
# RUN python -m pip install mlprodict==0.8.1762

# # Nemo
# RUN pip install nemo_toolkit[all]

# # save downloaded models:
# # pytorch  NeMo models: /home/jovyan/.cache/torch/NeMo
# # huggingface transformers models: /home/jovyan/.cache/huggingface

# # save datasets:
# # kaggle: /home/jovyan/.cache/kaggle
# # tensorflow: /home/jovyan/.cache/tensorflow_datasets

# # Install nemo with pip from source. Select branch directly in https://github.com/NVIDIA page,
# # current branch is main, select revision branch
# # RUN python -m pip install git+https://github.com/NVIDIA/NeMo.git@r1.4.0#egg=nemo_toolkit[all]

RUN pip freeze

WORKDIR /home/jovyan/work
EXPOSE 8888