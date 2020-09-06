pipeline {
    agent any
    stages {
        stage('Build') {
            environment { 
                USER=credentials('jenkins-current-user')
                DOCKER_CREDS=credentials('jenkins-docker-credentials')
                RSTUDIO_COMMON_CREDS = credentials('jenkins-rstudio-common-creds')
                MONGO_COMMON_CREDS = credentials('jenkins-mongo-common-creds')
                MONGO_FHQ = credentials('jenkins-mongo-fh-creds')
                FLASK_SECRET_KEY = credentials('fh-flask-secret-key')
            }            
            steps {
                labelledShell label: 'Building and tagging docker images...', script: '''
                    export GIT_VERSION=$(git describe --tags | sed s/v//)
                    docker build -t $USER/xvfb:latest xvfb/.
                    docker build -t $USER/tensorflow:latest .
                    docker tag $USER/xvfb:latest $USER/xvfb:$GIT_VERSION
                    docker tag $USER/tensorflow:latest $USER/tensorflow:$GIT_VERSION
                '''
                labelledShell label: 'Stopping exitsting containers...', script: '''
                    docker stop tensorflow || true && docker rm tensorflow || true
                    docker system prune -f # remove orphan containers, volumes, networks and images
                    # recreate networks after system pruning
                    docker network create xvfb || true
                    docker network create db-connection || true
                '''
                labelledShell label: 'Pushing images to docker registry...', script: '''
                    echo 'login to docker'
                    docker login -u $DOCKER_CREDS_USR  -p $DOCKER_CREDS_PSW
                    export GIT_VERSION=$(git describe --tags | sed s/v//)
                    echo $GIT_VERSION
                    echo "Pushing tensorflow:$GIT_VERSION to docker hub"
                    docker push $USER/xvfb:$GIT_VERSION
                    docker push $USER/xvfb:latest
                    docker push $USER/tensorflow:$GIT_VERSION
                    docker push $USER/tensorflow:latest
                '''
                labelledShell label: 'Starting docker containers Xvfb and tensorflow', script: '''
                    docker run --name xvfb $USER/xvfb -d -rm -p 99:99 --network=xvfb
                    docker run --gpus all --shm-size=1g --ulimit memlock=-1 \
                        -d --name tensorflow \
                        -p 8888:8888 -p 6006:6006 \
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
                        --rm aabor/tensorflow:latest
                    docker network connect db-connection tensorflow 
                '''
            }
            post {
                always{
                    cleanWs()
                    emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}",
                        recipientProviders: [[$class: 'DevelopersRecipientProvider'], 
                        [$class: 'RequesterRecipientProvider']],
                        subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"
                }
            }
        }
    }
}
