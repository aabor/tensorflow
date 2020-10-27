# recreate networks after system pruning
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
#-u $(id -u):$(id -g) \
docker run -d \
    --name xvfb \
    -p 99:99 --network=xvfb \
    -rm $USER/xvfb 
docker run --gpus all --shm-size=1g --ulimit memlock=-1 \
    -d --name tensorflow \
    -p 8888:8888 -p 6006:6006 -p 8050:8050\
    --network=xvfb \
    -e "DISPLAY=xvfb:99" \
    -e "TZ=EEST" \
    -e "WERKZEUG_DEBUG_PIN='off'" \
    -e "MONGODB_DATABASE=flaskdb" \
    -e "MONGODB_USERNAME=$USER" \
    -e "MONGODB_PASSWORD=$MONGO_COMMON_CREDS_PSW" \
    -e "MONGODB_FH_PASSWORD=$MONGO_FHQ_PSW" \
    -e "FLASK_SECRET_KEY=$FLASK_SECRET_KEY" \
    -e "MONGODB_HOSTNAME=mongo" \
    -v "/etc/X11/xorg.conf:/etc/X11/xorg.conf" \
    -v "/etc/lightdm/lightdm.conf:/etc/lightdm/lightdm.conf" \
    -v "/home/$USER/projects:/tf/projects" \
    -v "/home/$USER/.jupyter:/root/.jupyter" \
    -v "/home/$USER/.keras:/root/.keras" \
    -v "/home/$USER/.cache:/root/.cache" \
    -v "/home/$USER/.local/share/jupyter/nbextensions:/root/.local/share/jupyter/nbextensions" \
    -v "/home/$USER/.kaggle:/root/.kaggle" \
    -v "/home/$USER/.ssh:/root/.ssh/" \
    -v "/home/$USER/.secrets:/root/.secrets/" \
    -v "/home/$USER/.gitconfig:/root/.gitconfig" \
    -v /home/$USER/Documents:/tf/Documents \
    -v /home/$USER/Downloads:/tf/Downloads \
    -v /home/$USER/tensorflow_datasets:/root/tensorflow_datasets \
    -v /home/$USER/.logdir:/root/logs  \
    --rm aabor/tensorflow-gpu:latest
docker network connect db-connection tensorflow 

docker network connect db-connection tensorflow 
docker ps --filter "name=tensorflow" --format "{{.ID}}: {{.Status}}: {{.Names}}: {{.Ports}}"
#docker stop $(docker ps -a -q);  docker rm $(docker ps -a -q)