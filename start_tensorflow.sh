docker network create xvfb || true
docker network create db-connection || true
echo "networks created"
mkdir -p "/home/$USER/.jupyter"
mkdir -p "/home/$USER/.keras"
mkdir -p "/home/$USER/.cache:"
mkdir -p "/home/$USER/.local/share/jupyter/nbextensions"
mkdir -p "/home/$USER/.ssh"
mkdir -p "/home/$USER/.secrets"
mkdir -p "/home/$USER/Downloads"
mkdir -p "/home/$USER/tensorflow_datasets"
mkdir -p "/home/$USER/.logdir"
echo "directories created"
docker run --gpus all --shm-size=1g --ulimit memlock=-1 \
                        -d --name tensorflow \
                        -p 8888:8888 -p 6006:6006 -p 8050:8050\
                        --network=xvfb \
                        -e "DISPLAY=xvfb:99" \
                        -e "TZ=EEST" \
                        -e "WERKZEUG_DEBUG_PIN='off'" \
                        -v "/home/$USER/projects:/tf/projects" \
                        -v "/home/$USER/.jupyter:/root/.jupyter" \
                        -v "/home/$USER/.keras:/root/.keras" \
                        -v "/home/$USER/.cache:/root/.cache" \
                        -v "/home/$USER/.local/share/jupyter/nbextensions:/root/.local/share/jupyter/nbextensions" \
                        -v "/home/$USER/.ssh:/root/.ssh/" \
                        -v "/home/$USER/.secrets:/root/.secrets/" \
                        -v "/home/$USER/.gitconfig:/root/.gitconfig" \
                        -v "/home/$USER/Downloads:/tf/Downloads" \
                        -v "/home/$USER/tensorflow_datasets:/root/tensorflow_datasets" \
                        -v "/home/$USER/.logdir:/root/logs"  \
                        --rm aabor/tensorflow:latest
docker network connect db-connection tensorflow 
docker ps