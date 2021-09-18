# aabor/tensorflow
# configured for automatic build
# Find Dockerfiles:
# https://github.com/tensorflow/tensorflow/tree/master/tensorflow/tools/dockerfiles
# Inspect Dockerfile digest at the docker hub repository
# to find CUDA version in the image
#
# To find CUDA version at the host run in the host console:
# nvidia-smi 
#
FROM tensorflow/tensorflow:2.5.1-gpu-jupyter
# FROM nvcr.io/nvidia/cudagl:11.3.1-devel-ubuntu18.04

# installation utilities
RUN  apt-get update && apt-get install -y \
  wget zip unzip make cron nano vim tree \
  build-essential \
  && apt-get clean

# ssh 
RUN  apt-get update && apt-get install -y \
  openssh-server \
  xclip \
  && apt-get clean

## gnupg is needed to add new key 
RUN apt-get update && apt-get install -y \
  gnupg2 \
  && apt-get clean

RUN apt-get update && apt-get install -y \
  gcc \
  binutils \
  cmake \
  ffmpeg \
  && apt-get clean

# xvfb
RUN apt-get update && apt-get -y install libgl1 freeglut3-dev xvfb

RUN apt-get update && apt-get install -y \
  libsm6 libxext6 libxrender-dev \
  libjpeg-dev libpng-dev \
  libtiff5-dev \
  && apt-get clean
RUN apt-get update && apt-get install -y \
  imagemagick && convert --version

# PyQt5
RUN pip install PyQt5
RUN apt-get update && apt-get install -y \
  python3-pyqt5 \
  pyqt5-dev-tools \
  qttools5-dev-tools \
  x11-utils \
  mesa-utils \
  xvfb \
  && apt-get clean

RUN echo $CUDA_VERSION
# cuda-11.2
# https://www.tensorflow.org/install/source
RUN pip install tensorflow
RUN pip install tensorflow_datasets tensorflow_hub kaggle 

RUN pip install "dask[dataframe]" --upgrade

RUN pip install mpmath sympy numba

RUN pip install cupy-cuda112

# install Jupyter notebooks extentions
# https://github.com/ipython-contrib/jupyter_contrib_nbextensions
RUN pip install jupyter_contrib_nbextensions 
#RUN jupyter contrib nbextension install --user
RUN pip install jupyter_nbextensions_configurator
#RUN jupyter nbextensions_configurator enable --user
# in notebook with mounted external folder .jupyter:/root/.jupyter
#!jupyter nbextension en 5xable ...
# in jupyter_nbextensions_configurator enable scrolldown autoscroll
RUN pip install yapf
RUN pip uninstall jedi --yes

RUN pip install dataclasses pyzipper
# RUN pip install -U spacy[cuda112]
# RUN python -m spacy download en_core_web_sm
# RUN pip install transformers
# RUN pip install gym 
# RUN pip install gym[atari]
# RUN pip install edward


RUN pip install mysql-connector-python pymongo Flask-Session flask-mongo-sessions
RUN pip install pytest testpath mime pause humanfriendly dataset tabulate
RUN pip install openpyxl xlsxwriter tqdm

RUN pip install Flask Flask-Bcrypt Flask-Cors Flask-JWT-Extended Flask-Login pytest-flask
RUN pip install Flask-Session
RUN pip install flask-mongo-sessions

RUN pip install importlib-metadata itsdangerous jsonschema mccabe more-itertools nbconvert
RUN pip install pymongo arctic dask 
RUN pip install pause humanfriendly pytest
RUN pip install python-dateutil pyzmq qtconsole six testpath text-unidecode mime 

RUN pip install notebook>=5.3 ipywidgets>=7.2
RUN pip install -U kaleido
RUN pip install dash==1.15.0
RUN pip install toolz

RUN pip install --upgrade mplfinance==0.12.7a17

RUN jupyter nbextension enable --py widgetsnbextension
RUN pip install jupyterthemes

RUN pip freeze

