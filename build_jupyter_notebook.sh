# Get official git repository with source code for building ready-to-run 
# Docker images containing Jupyter applications
cd ~/projects/
git clone https://github.com/jupyter/docker-stacks

# find out your user ID on the server side
id $USER
# uid=1005(aabor) gid=1005(aabor) groups=1005(aabor),4(adm),24(cdrom),27(sudo),...

# create custom base-notebook docker image by setting docker build argument
# to current user ID
cd ~/projects/docker-stacks/base-notebook
DOCKER_BUILDKIT=1 docker build -t $USER/base-notebook:python-3.8.13 \
    --build-arg PYTHON_VERSION=3.8.13 \
    --build-arg NB_UID=1005 \
    .

DOCKER_BUILDKIT=1 docker build -t $USER/tensorrt:1.3.0 \
    --build-arg ROOT_CONTAINER=$USER/base-notebook:python-3.8.13 \
    .
# # build more verbosely
# docker build --no-cache --progress plain -t $USER/base-notebook:python-3.8.13 .
