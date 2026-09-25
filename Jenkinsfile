pipeline {

    agent any

    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git credentialsId: 'YOUR_GITHUB_CREDENTIALS_ID',
                    url: 'https://github.com/ramasubramanian06/python-jenkins-project.git',
                    branch: 'main'
            }
        }

        stage('Build Docker') {
            steps {
                script {
                    sh '''
                    echo 'Build Docker Image'
                    docker build -t ramasubramanian06/todo-app:${BUILD_NUMBER} .
                    '''
                }
            }
        }

        stage('Push the artifacts') {
            steps {
                script {
                    sh '''
                    echo 'Push to Repo'
                    docker push ramasubramanian06/todo-app:${BUILD_NUMBER}
                    '''
                }
            }
        }

        stage('Update K8S manifest & push to Repo') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'YOUR_GITHUB_CREDENTIALS_ID', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh '''
                        cat deploy.yaml
                        sed -i "s|ramasubramanian06/todo-app:.*|ramasubramanian06/todo-app:${BUILD_NUMBER}|g" deploy.yaml
                        cat deploy.yaml
                        git config user.email "jenkins@ci.local"
                        git config user.name "Jenkins CI"
                        git add deploy.yaml
                        git commit -m "Updated deploy.yaml image tag to ${BUILD_NUMBER} | Jenkins Pipeline"
                        git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/ramasubramanian06/python-jenkins-project.git HEAD:main
                        '''
                    }
                }
            }
        }
    }
}
