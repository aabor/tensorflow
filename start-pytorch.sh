docker network create xvfb || true
docker network create db-connection || true
echo "networks created" 
mkdir -p "/home/$USER/.jupyter"
mkdir -p "/home/$USER/.cache"
mkdir -p "/home/$USER/.cache/torch"
mkdir -p "/home/$USER/.cache/huggingface"
mkdir -p "/home/$USER/.cache/kaggle"
mkdir -p "/home/$USER/.cache/tensorflow_datasets"
mkdir -p "/home/$USER/.local/share/jupyter/nbextensions"
mkdir -p "/home/$USER/.log"
mkdir -p "/home/$USER/.secrets"
mkdir -p "/home/$USER/projects/Reporter/data/mnt/logs/reporter_logs"
mkdir -p "/home/$USER/projects/Reporter/data/mnt/logs/controller_logs"
mkdir -p "/home/$USER/projects/Reporter/data/mnt/AdminTool/Private"
mkdir -p "/home/$USER/projects/DeviceLanguage"

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
docker stop $(docker container ls -f name=pytorch -aq)
docker run --rm \
    --ulimit memlock=-1 \
    --gpus all \
    -d --name pytorch \
    -p 8888:8888 -p 6006:6006 -p 8050:8050\
    --network=xvfb \
    -e "DISPLAY=xvfb:99" \
    -e "TZ=EEST" \
    -e "WERKZEUG_DEBUG_PIN='off'" \
    -e "JUPYTER_ENABLE_LAB=yes" \
    -v "/etc/X11/xorg.conf:/etc/X11/xorg.conf" \
    -v "/etc/lightdm/lightdm.conf:/etc/lightdm/lightdm.conf" \
    -v "/home/$USER/projects:/home/jovyan/work" \
    -v "/home/$USER/.ipython:/home/jovyan/.ipython" \
    -v "/home/$USER/.jupyter:/home/jovyan/.jupyter" \
    -v "/home/$USER/.local/share:/home/jovyan/.local/share" \
    -v "/home/$USER/.cache/torch:/home/jovyan/.cache/torch" \
    -v "/home/$USER/.cache/huggingface:/home/jovyan/.cache/huggingface" \
    -v "/home/$USER/.cache/kaggle:/home/jovyan/.cache/kaggle" \
    -v "/home/$USER/.cache/punctuator:/home/jovyan/.cache/punctuator" \
    -v "/home/$USER/.cache/tensorflow_datasets":"/home/jovyan/.cache/tensorflow_datasets" \
    -v "/home/$USER/Documents":"/home/jovyan/Documents" \
    -v "/home/$USER/Downloads":"/home/jovyan/Downloads" \
    -v "/home/$USER/.logs":"/home/jovyan/.logs" \
    -v "/home/$USER/.gitconfig:/home/jovyan/.gitconfig" \
    -v "/home/$USER/.netrc:/home/jovyan/.netrc" \
    -v "/home/$USER/projects/Reporter/data/mnt/logs/reporter_logs:/root/reporter/logs" \
    -v "/home/$USER/projects/Reporter/data/mnt/logs/controller_logs:/opt/controller_logs" \
    -v "/home/$USER/projects/Reporter/data/mnt/AdminTool/Private:/opt/Private" \
    -v "/home/$USER/projects/DeviceLanguage:/root/reporter/DeviceLanguage" \
    aabor/pytorch-gpu:110cu113
    # aabor/pytorch-gpu:110cu102

docker network connect db-connection pytorch
docker ps --filter "name=pytorch" --format "{{.ID}}: {{.Status}}: {{.Names}}: {{.Ports}}"
#docker stop $(docker ps -a -q);  docker rm $(docker ps -a -q)
