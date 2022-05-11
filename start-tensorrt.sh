# docker build -t aabor/tensorrt:cuda116 .
docker network create xvfb || true
docker network create db-connection || true
echo "networks created" 
mkdir -p "/home/$USER/.jupyter"
mkdir -p "/home/$USER/.ipython"
mkdir -p "/home/$USER/.cache/torch"
mkdir -p "/home/$USER/.cache/huggingface"
mkdir -p "/home/$USER/.cache/kaggle"
mkdir -p "/home/$USER/.cache/tensorflow_datasets"
mkdir -p "/home/$USER/.local/share/jupyter"
mkdir -p "/home/$USER/.secrets"
mkdir -p "/home/$USER/log"
echo "directories created"
#-u $(id -u):$(id -g) \
# https://hub.docker.com/r/metal3d/xvfb
docker run -d \
    --name xvfb \
    -p 99:99 \
    --network=xvfb \
    metal3d/xvfb:0.0.1

# -e "JUPYTER_ENABLE_LAB=yes" starts JupyterLab instead of jupyter notebook that
# listens to the same port
docker stop $(docker container ls -f name=tensorrt -aq)
docker run --rm \
    --gpus all \
    -d \
    --shm-size=8gb --env="DISPLAY" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name tensorrt \
    -p 8888:8888 \
    -p 6006:6006 \
    -p 6007:6007 \
    -e "TZ=EEST" \
    -e "JUPYTER_ENABLE_LAB=yes" \
    -v "/home/$USER/projects/TensorRT:/workspace/TensorRT" \
    -v "/home/$USER/projects:/workspace/projects" \
    -v "/home/$USER/.ipython:/workspace/.ipython" \
    -v "/home/$USER/.jupyter:/workspace/.jupyter" \
    -v "/home/$USER/.netrc:/workspace/.netrc" \
    -v "/home/$USER/.local/share:/workspace/.local/share" \
    -v "/home/$USER/.cache/torch:/workspace/.cache/torch" \
    -v "/home/$USER/.cache/huggingface:/workspace/.cache/huggingface" \
    -v "/home/$USER/.cache/kaggle:/workspace/.cache/kaggle" \
    -v "/home/$USER/.cache/tensorflow_datasets:/workspace/.cache/tensorflow_datasets" \
    -v "/home/$USER/Documents:/workspace/Documents" \
    -v "/home/$USER/Downloads:/workspace/Downloads" \
    -v "/home/$USER/log:/workspace/log" \
    -v "/mnt/wd5000:/workspace/wd5000" \
    aabor/tensorrt:cuda116 \
    jupyter lab --no-browser --ip 0.0.0.0 --allow-root
    # tensorrt-ubuntu20.04-cuda11.4:latest \
    # jupyter-lab --port=8888 --no-browser --ip 0.0.0.0 --allow-root


docker network connect db-connection tensorrt
docker ps --filter "name=tensorrt" --format "{{.ID}}: {{.Status}}: {{.Names}}: {{.Ports}}"
#docker stop $(docker ps -a -q);  docker rm $(docker ps -a -q)
