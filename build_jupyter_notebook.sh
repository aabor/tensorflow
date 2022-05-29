# Get official git repository with source code for building ready-to-run Docker images containing Jupyter applications and interactive computing tools
cd ~/projects/
git clone https://github.com/jupyter/docker-stacks

cd ~/projects/docker-stacks/base-notebook
docker build -t $USER/base-notebook:python-3.8.13 \
    --build-arg PYTHON_VERSION=3.8.13 \
    --build-arg NB_UID=1005 \
    .

docker build -t $USER/tensorrt:1.3.0 \
    --build-arg ROOT_CONTAINER=$USER/base-notebook:python-3.8.13 \
    .
# # build more verbosely
# docker build --no-cache --progress plain -t $USER/tensorrt:1.3.0 .
