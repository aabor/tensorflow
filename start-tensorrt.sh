# docker build -t aabor/tensorrt:1.2.0 .
# docker build --no-cache --progress plain -t aabor/tensorrt:1.2.1 .
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
    -v "/home/$USER/projects:/home/jovyan/work" \
    -v "/home/$USER/.ipython:/home/jovyan/.ipython" \
    -v "/home/$USER/.jupyter:/home/jovyan/.jupyter" \
    -v "/home/$USER/.netrc:/home/jovyan/.netrc" \
    -v "/home/$USER/.local/share:/home/jovyan/.local/share" \
    -v "/home/$USER/.cache/torch:/home/jovyan/.cache/torch" \
    -v "/home/$USER/.cache/huggingface:/home/jovyan/.cache/huggingface" \
    -v "/home/$USER/.cache/kaggle:/home/jovyan/.cache/kaggle" \
    -v "/home/$USER/.cache/tensorflow_datasets:/home/jovyan/.cache/tensorflow_datasets" \
    -v "/home/$USER/Documents:/home/jovyan/Documents" \
    -v "/home/$USER/Downloads:/home/jovyan/Downloads" \
    -v "/home/$USER/log:/home/jovyan/log" \
    -v "/mnt/wd5000:/home/jovyan/wd5000" \
    aabor/tensorrt:1.2.2 \
    jupyter lab --no-browser --ip 0.0.0.0
    # tensorrt-ubuntu20.04-cuda11.4:latest \
    # jupyter-lab --port=8888 --no-browser --ip 0.0.0.0 --allow-root


docker network connect db-connection tensorrt
docker ps --filter "name=tensorrt" --format "{{.ID}}: {{.Status}}: {{.Names}}: {{.Ports}}"
#docker stop $(docker ps -a -q);  docker rm $(docker ps -a -q)

# # inside docker container
# sudo docker exec -it tensorrt /bin/bash
# # check versions
# jq -C '[.[] | .name +": "+ .version] '  /usr/local/cuda-11.3/version.json
# [
#   "CUDA SDK: 11.3.0",
#   "CUDA Runtime (cudart): 11.3.58",
#   "cuobjdump: 11.3.58",
#   "CUPTI: 11.3.58",
#   "CUDA cu++ filt: 11.3.58",
#   "CUDA Demo Suite: 11.3.58",
#   "CUDA GDB: 11.3.58",
#   "CUDA Memcheck: 11.3.58",
#   "Nsight Eclipse Plugins: 11.3.58",
#   "CUDA NVCC: 11.3.58",
#   "CUDA nvdisasm: 11.3.58",
#   "CUDA NVML Headers: 11.3.58",
#   "CUDA nvprof: 11.3.58",
#   "CUDA nvprune: 11.3.58",
#   "CUDA NVRTC: 11.3.58",
#   "CUDA NVTX: 11.3.58",
#   "CUDA NVVP: 11.3.58",
#   "CUDA Samples: 11.3.58",
#   "CUDA Compute Sanitizer API: 11.3.58",
#   "Fabric Manager: 465.19.01",
#   "CUDA cuBLAS: 11.4.2.10064",
#   "CUDA cuFFT: 10.4.2.58",
#   "CUDA cuRAND: 10.2.4.58",
#   "CUDA cuSOLVER: 11.1.1.58",
#   "CUDA cuSPARSE: 11.5.0.58",
#   "CUDA NPP: 11.3.3.44",
#   "CUDA nvJPEG: 11.4.1.58",
#   "Nsight Compute: 2021.1.0.18",
#   "Nsight Systems: 2021.1.3.14",
#   "NVIDIA Linux Driver: 465.19.01"
# ]
# dpkg -L libnvinfer8
# # /usr/lib/x86_64-linux-gnu/libnvinfer.so.8.4.0
# dpkg -L libnvonnxparser8
# # /usr/lib/x86_64-linux-gnu/libnvonnxparser.so.8.4.0
# dpkg -L libnvparsers8
# # /usr/lib/x86_64-linux-gnu/libnvparsers.so.8.4.0

