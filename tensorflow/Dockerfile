# aabor/tensorflow
# configured for automatic build
FROM tensorflow/tensorflow:2.4.1-jupyter

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

# install LaTeX support for python
RUN apt-get update && apt-get install -y \
  libpoppler-cpp-dev \
  && apt-get clean
RUN apt-get update && apt-get install -y \
  ghostscript \
  dvipng \
  && apt-get clean

RUN apt-get update && DEBIAN_FRONTEND='noninteractive' apt-get install -y \
  texlive-latex-extra \
  && apt-get clean


RUN pip install opencv-python

RUN apt-get update && apt-get install -y \
 graphviz \
 && apt-get clean

RUN pip install pydot

RUN apt-get update && apt-get install -y \
 cmake ffmpeg \
 && apt-get clean

RUN apt-get update && apt-get install -y imagemagick && convert --version

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
RUN pip install yapf

RUN pip install dataclasses pyzipper pyPDF4
RUN pip install tensorflow_datasets tensorflow_hub kaggle 
RUN pip install mysql-connector-python pymongo Flask-Session flask-mongo-sessions
RUN pip install pytest testpath mime pause humanfriendly dataset tabulate
RUN pip install openpyxl xlsxwriter tqdm
RUN pip install mpmath sympy
RUN pip install seaborn scikit-learn scikit-image xlearn
RUN pip install numba
RUN pip install gensim 
RUN pip install nltk

RUN pip install Flask Flask-Bcrypt Flask-Cors Flask-JWT-Extended Flask-Login pytest-flask
RUN pip install Flask-Session
RUN pip install flask-mongo-sessions

RUN pip install importlib-metadata itsdangerous jsonschema mccabe more-itertools nbconvert
RUN pip install pymongo arctic dask 
RUN pip install pause humanfriendly pytest
RUN pip install python-dateutil pyzmq qtconsole six testpath text-unidecode mime 
RUN pip install xlearn fuzzywuzzy

RUN pip install plotly==4.9.0
RUN pip install notebook>=5.3 ipywidgets>=7.2
RUN pip install -U kaleido
RUN pip install dash==1.15.0
RUN pip install toolz

RUN pip install ipywidgets
RUN jupyter nbextension enable --py widgetsnbextension
RUN pip install jupyterthemes
#RUN pip install --upgrade Pillow
RUN apt-get install -y python3-matplotlib

RUN  apt-get update && apt-get install -y xfonts-base xfonts-75dpi
RUN curl "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb" -L -o "wkhtmltopdf.deb"
RUN dpkg -i wkhtmltopdf.deb && rm wkhtmltopdf.deb

RUN pip install pdfkit htmlgen ll-xist htmlgenerator

RUN pip install wordcloud
RUN python3 -m nltk.downloader stopwords
RUN pip uninstall jedi --yes
RUN pip install colour
RUN pip install beautifulsoup4
RUN pip install open3d Shapely

RUN pip freeze

