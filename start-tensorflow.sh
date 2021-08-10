# docker swarm leave --force
# docker pull aabor/xvfb:2.0-4-gd6264a5
# docker pull aabor/tensorflow-gpu:2.0-4-gd6264a5
# docker pull aabor/tensorflow:2.0-4-gd6264a5
# docker pull aabor/mongo:latest
# docker pull aabor/rstudio:2.1-10-g4718c52
# docker pull aabor/rstudio-finance:2.1-10-g4718c52
# docker pull aabor/rstudio-text:2.1-10-g4718c52
# recreate networks after system pruning
docker network create xvfb || true
docker network create -d overlay --attachable db-connection || true
docker network create -d overlay --attachable selenium-hub || true
echo "networks created"
mkdir -p "/home/$USER/.jupyter"
mkdir -p "/home/$USER/.keras"
mkdir -p "/home/$USER/.cache:"
mkdir -p "/home/$USER/.local/share/jupyter/nbextensions"
mkdir -p "/home/$USER/.ssh"
mkdir -p "/home/$USER/.secrets"
mkdir -p "/home/$USER/tensorflow_datasets"
mkdir -p "/home/$USER/.logdir"
echo "directories created"
#-u $(id -u):$(id -g) \
# https://hub.docker.com/r/metal3d/xvfb
docker run -d \
    --name xvfb \
    -p 99:99 \
    --network=xvfb \
    metal3d/xvfb:0.0.1

docker stop $(docker container ls -f name=tensorflow -aq)
docker run --rm \
    --gpus all --shm-size=1g \
    --ulimit memlock=-1 \
    -d --name tensorflow \
    -p 8888:8888 -p 6006:6006 -p 8050:8050\
    --network=xvfb \
    -e "DISPLAY=xvfb:99" \
    -e "TZ=EEST" \
    -e "WERKZEUG_DEBUG_PIN='off'" \
    -e PYTHONPATH=/tf/projects/fhq \
    -e "MONGODB_DATABASE=flaskdb" \
    -e "MONGODB_USERNAME=$USER" \
    -e MONGODB_PASSWORD=$(pass docker/mongo_common_psw) \
    -e MONGODB_FH_PASSWORD=$(pass docker/mongo_fhq_psw) \
    -e FLASK_SECRET_KEY=$(pass docker/flask_secret_key) \
    -e MYSQL_ROOT_PASSWORD=$(pass docker/mysql_root_psw) \
    -e MYSQL_PASSWORD="$(pass docker/mysql_user_psw)" \
    -e MYSQL_USER="$USER" \
    -e MYSQL_DATABASE="edu" \
    -e MYSQL_ROOT_HOST="172.*.*.*" \
    -e "MONGODB_HOSTNAME=mongo" \
    -v "/etc/X11/xorg.conf:/etc/X11/xorg.conf" \
    -v "/etc/lightdm/lightdm.conf:/etc/lightdm/lightdm.conf" \
    -v "/home/$USER/projects:/tf/projects" \
    -v "/home/$USER/.jupyter:/root/.jupyter" \
    -v "/home/$USER/.ipython:/root/.ipython" \
    -v "/home/$USER/.keras:/root/.keras" \
    -v "/home/$USER/.fh:/root/.fh" \
    -v "/home/$USER/.cache:/root/.cache" \
    -v "/home/$USER/.local/share/jupyter/nbextensions:/root/.local/share/jupyter/nbextensions" \
    -v "/home/$USER/.kaggle:/root/.kaggle" \
    -v "/home/$USER/.ssh:/root/.ssh/" \
    -v "/home/$USER/.secrets:/root/.secrets/" \
    -v "/home/$USER/.gitconfig:/root/.gitconfig" \
    -v /home/$USER/Documents:/tf/Documents \
    -v /home/$USER/Downloads:/tf/Downloads \
    -v /home/$USER/tensorflow_datasets:/root/tensorflow_datasets \
    -v /home/$USER/.logdir:/root/logs \
    aabor/tensorflow-gpu:4.0.4

docker network connect db-connection tensorflow 
docker ps --filter "name=tensorflow" --format "{{.ID}}: {{.Status}}: {{.Names}}: {{.Ports}}"
#docker stop $(docker ps -a -q);  docker rm $(docker ps -a -q)