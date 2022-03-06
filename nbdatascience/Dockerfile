# aabor/nbdatascience
# configured for automatic build
FROM jupyter/tensorflow-notebook:8b4d6f6ac0d7

LABEL maintainer="A. Borochkin <aabor@aabor-nn.com>"

USER root
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

USER jovyan

RUN jupyter lab build 

RUN jupyter labextension install nbdime-jupyterlab
RUN jupyter labextension install -y @jupyterlab/toc
#RUN jupyter labextension install -y @jupyterlab/git
RUN pip install jupyterlab-git 
RUN jupyter serverextension enable --py jupyterlab_git

COPY requirements.txt /opt/app/
WORKDIR /opt/app

RUN pip install -r requirements.txt

RUN conda install numba cudatoolkit

# Arctic MongoDB-powered financial tick store. It supports Pandas, numpy arrays and pickled objects out-of-the-box, with pluggable support for other data types and optional versioning
RUN pip install git+https://github.com/manahl/arctic.git

RUN python -m spacy download en_core_web_lg
RUN pip install Flask-Session
RUN pip install flask-mongo-sessions

RUN pip freeze

WORKDIR /home/jovyan/work
