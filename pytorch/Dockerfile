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
    qpdf=9.1.1-1ubuntu0.1 \
    ghostscript=9.50~dfsg-5ubuntu4.4 \
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
RUN pip install jupyterlab-theme-solarized-dark

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

RUN 	python -m pip install consulate \
                            h2 \
                            grpcio \
                            grpcio-tools \
                            chardet \
                            consulate \
                            filelock \
                            mysql-connector-python \
                            paho-mqtt \
                            aiofile \
                            pycrypto \
                            setuptools \
                            certifi \
                            words2num \
                            requests \
                            pyyaml \
                            aiohttp \
                            six \
                            urllib3 \
                            pipdeptree \
                            aiodns \
                            setproctitle \
                            psutil \
                            numpy \
                            pandas \
                            PyPDF4 \
                            ImageColor \
                            APScheduler \
                            asgiref \
                            toolz \
                            Pillow \
                            nltk \
                            openpyxl \
                            dataclasses \
                            pyzipper \
                            matplotlib \
                            pdfkit \
                            wordcloud \
                            Jinja2 \
                            urllib3 \
                            requests \
                            colour \
                            beautifulsoup4 \
                            python-dateutil \
                            graphviz \
                            pygraphviz \
                            phonenumbers \
                            onnxruntime \
                            tf2onnx \
                            skl2onnx \
                            nbconvert

RUN python3 -m pip install onnx_graphsurgeon --index-url https://pypi.ngc.nvidia.com

# only for CUDA environments
RUN python3 -m pip install --upgrade setuptools pip
RUN python3 -m pip install nvidia-pyindex
RUN python3 -m pip install --upgrade nvidia-tensorrt

RUN pip freeze
