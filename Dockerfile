# aabor/tensorflow
# configured for automatic build
FROM tensorflow/tensorflow:2.3.0rc2-gpu-jupyter

LABEL maintainer="A. A. Borochkin"

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
  && apt-get clean

RUN pip install -U setuptools pip

RUN apt-get update && apt-get install -y \
  libsm6 libxext6 libxrender-dev \
  libjpeg-dev libpng-dev \
  libtiff5-dev \
  && apt-get clean

RUN pip install opencv-python

RUN apt-get update && apt-get install -y \
 graphviz \
 && apt-get clean

RUN pip install pydot

RUN apt-get update && apt-get install -y \
 cmake ffmpeg \
 && apt-get clean

RUN apt-get update
RUN mkdir /tf/tmp
RUN wget -c https://www.imagemagick.org/download/ImageMagick.tar.gz -O - | tar -xz
RUN mv ImageMagick* /tf/tmp/ImageMagick
WORKDIR /tf/tmp/ImageMagick
RUN ./configure
RUN make
RUN make install
RUN ldconfig /usr/local/lib
RUN magick --version
WORKDIR /tf
RUN rm -R tmp

RUN apt-get update && apt-get install -y \
  python-opengl \
  && apt-get clean

# install Jupyter notebooks extentions
# https://github.com/ipython-contrib/jupyter_contrib_nbextensions
RUN pip install jupyter_contrib_nbextensions 
#RUN jupyter contrib nbextension install --user
RUN pip install jupyter_nbextensions_configurator
#RUN jupyter nbextensions_configurator enable --user
# in notebook with mounted external folder .jupyter:/root/.jupyter
#!jupyter nbextension en 5xable ...
# in jupyter_nbextensions_configurator enable scrolldown autoscroll

RUN pip install tensorflow_datasets tensorflow_hub
RUN pip install  mysql-connector-python pymongo Flask-Session flask-mongo-sessions
RUN pip install pytest pytest-flask testpath mime dataset openpyxl
RUN pip install mpmath sympy
RUN pip install seaborn scikit-learn scikit-image xlearn
RUN pip install numba
RUN pip install kaggle pause humanfriendly
RUN pip install gensim 
RUN cat /usr/local/cuda/version.txt
RUN pip install cupy-cuda101
RUN pip install -U spacy[cuda101]
RUN python -m spacy download en_core_web_sm
RUN pip install torch==1.6.0+cu101 torchvision==0.7.0+cu101 \
  -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install transformers
RUN pip install nltk
RUN pip install edward
RUN pip install gym 
RUN pip install gym[atari]

