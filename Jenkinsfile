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
                    docker build -t $USER/tensorflow-gpu:latest tensorflow-gpu/.
                    docker build -t $USER/tensorflow:latest tensorflow/.
                    docker tag $USER/xvfb:latest $USER/xvfb:$GIT_VERSION
                    docker tag $USER/tensorflow-gpu:latest $USER/tensorflow-gpu:$GIT_VERSION
                    docker tag $USER/tensorflow:latest $USER/tensorflow:$GIT_VERSION
                '''
                labelledShell label: 'Stopping exitsting containers...', script: '''
                    docker stop tensorflow || true && docker rm tensorflow || true
                    docker system prune -f # remove orphan containers, volumes, networks and images
                '''
                labelledShell label: 'Pushing images to docker registry...', script: '''
                    echo 'login to docker'
                    docker login -u $DOCKER_CREDS_USR  -p $DOCKER_CREDS_PSW
                    #docker login
                    export GIT_VERSION=$(git describe --tags | sed s/v//)
                    echo $GIT_VERSION
                    echo "Pushing tensorflow:$GIT_VERSION to docker hub"
                    docker push $USER/xvfb:$GIT_VERSION
                    docker push $USER/xvfb:latest
                    docker push $USER/tensorflow-gpu:$GIT_VERSION
                    docker push $USER/tensorflow-gpu:latest
                    docker push $USER/tensorflow:$GIT_VERSION
                    docker push $USER/tensorflow:latest
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
