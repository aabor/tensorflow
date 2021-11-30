# aabor/tensorflow
# configured for automatic build
FROM jupyter/base-notebook:python-3.9.7
# docker pull pytorch/pytorch:1.9.1-cuda11.1-cudnn8-runtime
# FROM pytorch/pytorch:1.9.1-cuda11.1-cudnn8-runtime

LABEL maintainer="A. A. Borochkin"

# https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ENV TZ=UTC
# ENV DEBIAN_FRONTEND=noninteractive

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

# installation utilities
RUN  apt-get update && apt-get install -y \
  apt-utils \
  wget zip unzip cron nano vim tree \
  curl gnupg2 \
  git \
  && apt-get clean

# for pytorch and NeMo libraries
RUN apt-get update && apt-get install -y \
  gcc make g++ build-essential \
  && apt-get clean
RUN apt-get update && apt-get install -y \
  libsndfile1 ffmpeg \
  && apt-get clean

RUN apt-get update && apt-get install -y --no-install-recommends \
    qpdf \
    ghostscript \
    && apt-get clean

RUN apt-get update && apt-get install -y --no-install-recommends \
    graphviz \
    libgraphviz-dev \
    pkg-config \
    && apt-get clean

RUN apt list -a qpdf
RUN apt list -a ghostscript

# need for nbconvert
RUN apt-get update && apt-get install -y \
  pandoc \
  texlive-xetex texlive-fonts-recommended texlive-plain-generic

# Install Node.js and npm for JupyterLab extensions
# Download and execute the NodeSource installation script
RUN curl -sL https://deb.nodesource.com/setup_16.x  | bash -
# The nodejs package contains both the node and npm binaries
RUN apt-get -y install nodejs


# install pyton packages as normal user
USER ${NB_UID}

RUN pip install -U setuptools pip

RUN pip install Cython 

RUN pip install --upgrade jupyterlab jupyterlab-git

# JupyterLab extentions
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
  jupyterlab-topbar-extension \
  jupyterlab-theme-solarized-dark

RUN jupyter labextension list

# # install Jupyter notebooks extentions
# # https://github.com/ipython-contrib/jupyter_contrib_nbextensions
# RUN pip install jupyter_contrib_nbextensions 
# #RUN jupyter contrib nbextension install --user
# RUN pip install jupyter_nbextensions_configurator
# #RUN jupyter nbextensions_configurator enable --user
# # in notebook with mounted external folder .jupyter:/root/.jupyter
# #!jupyter nbextension en 5xable ...
# # in jupyter_nbextensions_configurator enable scrolldown autoscroll
# RUN pip install notebook>=5.3 ipywidgets>=7.2
# RUN pip install ipywidgets
# RUN jupyter nbextension enable --py widgetsnbextension
# RUN pip install jupyterthemes yapf

RUN pip install numba

RUN pip install theano

RUN pip install omegaconf

# check official site to get correct installation command for pytorch
# https://pytorch.org/get-started/locally/
RUN pip3 install torch==1.10.0+cu113 torchvision==0.11.1+cu113 torchaudio==0.10.0+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html
# Hugging Face Transformers
RUN pip install "transformers[sentencepiece]"

# Nemo
RUN pip install wget unidecode

RUN pip install nemo_toolkit[all]

# data sources
RUN pip install datasets kaggle

RUN pip install punctuator
ENV PUNCTUATOR_DATA_DIR=~/.cache/punctuator
# save downloaded models:
# pytorch  NeMo models: /home/jovyan/.cache/torch/NeMo
# huggingface transformers models: /home/jovyan/.cache/huggingface

# save datasets:
# kaggle: /home/jovyan/.cache/kaggle
# tensorflow: /home/jovyan/.cache/tensorflow_datasets

# Install nemo with pip from source. Select branch directly in https://github.com/NVIDIA page,
# current branch is main, select revision branch
# RUN python -m pip install git+https://github.com/NVIDIA/NeMo.git@r1.4.0#egg=nemo_toolkit[all]

RUN 	python -m pip install consulate==0.6.0 \
                 h2==3.0.1 \
                 grpcio==1.38.1 \
                 grpcio-tools==1.38.1 \
                 chardet==3.0.4 \
                 googleapis-common-protos==1.5.3 \
                 consulate==0.6.0 \
                 filelock==3.0.10 \
                 mysql-connector-python==8.0.24 \
                 paho-mqtt==1.4.0 \
                 aiofile==1.4.3 \
                 pycrypto==2.6.1 \
                 setuptools==20.7.0 \
                 certifi==2018.11.29 \
                 words2num==0.2.3 \
                 requests==2.21.0 \
                 pyyaml==3.13 \
                 aiohttp==3.4.4 \
                 six==1.12.0 \
                 urllib3==1.24.1 \
                 pipdeptree==2.0.0 \
                 aiodns==1.1.1 \
                 setproctitle==1.1.10 \
                 psutil==5.6.3 \
                 numpy~=1.19.5 \
                 pandas~=1.1.5 \
                 PyPDF4~=1.27.0 \
                 ImageColor~=1.2.1 \
                 APScheduler~=3.7.0 \
                 asgiref~=3.4.1 \
                 toolz~=0.11.1 \
                 Pillow~=8.3.1 \
                 nltk~=3.6.2 \
                 openpyxl~=3.0.7 \
                 dataclasses~=0.6 \
                 pyzipper~=0.3.5 \
                 matplotlib~=3.3.4 \
                 pdfkit~=0.6.1 \
                 wordcloud~=1.8.1 \
                 Jinja2~=3.0.1 \
                 urllib3~=1.24.1 \
                 requests~=2.21.0 \
                 colour~=0.1.5 \
                 beautifulsoup4~=4.9.3 \
                 python-dateutil~=2.8.2 \
                 graphviz~=0.17 \
                 pygraphviz~=1.6 \
                 phonenumbers~=8.12.36 \
                 onnxruntime~=1.9.0 \
                 tf2onnx~=1.9.3 \
                 skl2onnx~=1.10.3 \
                 nbconvert

RUN python3 -m pip install onnx_graphsurgeon --index-url https://pypi.ngc.nvidia.com

# only for CUDA environments
# RUN python3 -m pip install --upgrade setuptools pip
# RUN python3 -m pip install nvidia-pyindex
# RUN python3 -m pip install --upgrade nvidia-tensorrt

RUN pip freeze