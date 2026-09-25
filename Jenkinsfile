pipeline {

    agent any
    options {
        skipDefaultCheckout(true)
    }

    environment {
        IMAGE_NAME = "ramasubramanian06/todo-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git credentialsId: 'github-credentials',
                    url: 'https://github.com/ramasubramanian06/python-jenkins-project.git',
                    branch: 'main'
            }
        }

        stage('Build Docker') {
            steps {
                sh '''
                    echo "Building Docker Image"
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "Login to Docker Hub"

                        echo "$DOCKER_PASSWORD" | docker login \
                        -u "$DOCKER_USERNAME" \
                        --password-stdin

                        echo "Pushing Docker Image"

                        docker push ${IMAGE_NAME}:${IMAGE_TAG}

                        docker logout
                    '''
                }
            }
        }

        stage('Update K8S manifest & push to Repo') {
            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'github-credentials',
                        usernameVariable: 'GIT_USERNAME',
                        passwordVariable: 'GIT_PASSWORD'
                    )
                ]) {

                    sh '''
                        echo "Current deployment manifest:"
                        cat kubernetes/deploy.yaml

                        echo "Updating Docker image tag..."

                        sed -i "s|ramasubramanian06/todo-app:.*|${IMAGE_NAME}:${IMAGE_TAG}|g" kubernetes/deploy.yaml

                        echo "Updated deployment manifest:"
                        cat kubernetes/deploy.yaml

                        git config user.email "jenkins@ci.local"
                        git config user.name "Jenkins CI"

                        git add kubernetes/deploy.yaml

                        git commit -m "Update todo-app image to ${IMAGE_TAG} [skip ci]"

                        git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/ramasubramanian06/python-jenkins-project.git HEAD:main
                    '''
                }
            }
        }
    }
}
