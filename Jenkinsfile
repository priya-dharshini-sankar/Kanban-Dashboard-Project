pipeline {
    agent any

    environment {
        IMAGE = 'priyanp/project-kanban-dashboard'
        CONTAINER = 'project-kanban-dashboard'
        PORT = '8081'
    }

    stages {


        stage('Checkout Source') {
            steps {
                checkout scm

                script{
                    env.GIT_SHA = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()
                }

                echo "Git SHA: ${GIT_SHA}"
            }
        }


        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${IMAGE}:build-${BUILD_NUMBER}-${GIT_SHA} .
                '''

                echo "Docker image built: ${IMAGE}:build-${BUILD_NUMBER}-${GIT_SHA}"
            }
        }


        stage ('Registry Login + Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE}:build-${BUILD_NUMBER}-${GIT_SHA}
                        docker logout
                    '''
                }
                echo "Docker image pushed successfully."
            }
        }


        stage ('Deploy to EC2') {
            steps {
                sh '''
                    # Save the currently running image for rollback
                    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
                        docker inspect ${CONTAINER} --format='{{.Config.Image}}' > previous_image.txt

                        echo "Previous image:"
                        cat previous_image.txt
                    else
                        echo "No running container found."
                        touch previous_image.txt
                    fi

                    # Pull the new image
                    docker pull ${IMAGE}:build-${BUILD_NUMBER}-${GIT_SHA}

                    # Stop and remove old container
                    docker stop ${CONTAINER} || true
                    docker rm ${CONTAINER} || true

                    # Start new container
                    docker run -d --name ${CONTAINER} --restart unless-stopped -p ${PORT}:80 ${IMAGE}:build-${BUILD_NUMBER}-${GIT_SHA}
            
                echo "New container deployed."
            '''
            }
        }

        stage ('Health Check') {
            steps {
                sh '''
                    echo "Waiting for container to become healthy..."
                    sleep 10

                    STATUS=$(docker inspect --format='{{.State.Health.Status}}' ${CONTAINER})

                    echo "Container health status: $STATUS"

                    if [ "$STATUS" != "healthy" ]; then
                        echo "Health check failed!"
                        exit 1
                    fi

                    echo "Health check PASSED"
                '''
            }
        }    
    }

post {

    success {
        echo "==========================================="
        echo "CI/CD PIPELINE SUCCESS"
        echo "Image: ${IMAGE}:build-${BUILD_NUMBER}-${GIT_SHA}"
        echo "==========================================="
    }

    failure {
        echo "==========================================="
        echo "CI/CD PIPELINE FAILED"
        echo "Starting rollback..."
        echo "==========================================="

        sh '''
            if [ -s previous_image.txt ]; then

                    PREVIOUS_IMAGE=$(cat previous_image.txt)

                    echo "Rolling back to: $PREVIOUS_IMAGE"

                    docker stop ${CONTAINER} || true
                    docker rm ${CONTAINER} || true

                    docker run -d --name ${CONTAINER} --restart unless-stopped -p ${PORT}:80 ${PREVIOUS_IMAGE}

                    echo "Rollback completed."

                else
                    echo "No previous image available."
                    echo "Rollback could not be performed."
                fi
            '''
        }
    }
}






