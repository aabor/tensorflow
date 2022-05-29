# Build base-notebook

Select specific python specific release
https://www.python.org/downloads/

```sh
# Get official git repository with source code for building ready-to-run Docker images containing Jupyter applications and interactive computing tools
cd ~/projects/
git clone https://github.com/jupyter/docker-stacks

cd ~/projects/docker-stacks/base-notebook
docker build -t aabor/base-notebook:python-3.8.13 \
    --build-arg PYTHON_VERSION=3.8.13 \
    --build-arg NB_UID=1000 \
    .

docker build -t aabor/aabor/tensorrt:1.3.0 \
    --build-arg ROOT_CONTAINER=aabor/base-notebook:python-3.8.13 \
    .
```