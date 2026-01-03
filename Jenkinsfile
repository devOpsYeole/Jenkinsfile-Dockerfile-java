pipeline {
    agent any

    parameters {
        choice(
            name: 'ENV',
            choices: ['dev', 'qa', 'prod'],
            description: 'Select deployment environment'
        )
    }

    environment {
        IMAGE_NAME     = "java_app"
        TAG            = "v1"
        CONTAINER_NAME = "java_app_container"
        DEPLOY_ENV     = "${params.ENV}"
    }

    stages {

        stage("Checkout") {
            steps {
                echo "Code checked out from SCM"
            }
        }

        stage("Build Java App") {
            steps {
                sh '''
                mvn clean package
                '''
            }
        }

        stage("Build Docker Image") {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:$TAG .
                '''
            }
        }

        stage("Push Image to Docker Hub") {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    docker login -u $DOCKER_USER -p $DOCKER_PASS
                    docker tag $IMAGE_NAME:$TAG $DOCKER_USER/$IMAGE_NAME:$TAG
                    docker push $DOCKER_USER/$IMAGE_NAME:$TAG
                    '''
                }
            }
        }

        stage("Deploy Container") {
            steps {
                sh '''
                echo "Deploying to $DEPLOY_ENV environment"

                docker rm -f $CONTAINER_NAME || true

                docker run -d \
                  --name $CONTAINER_NAME \
                  $IMAGE_NAME:$TAG
                '''
            }
        }
    }

    post {
        success {
            echo "Java CI/CD Pipeline SUCCESS"
        }
        failure {
            echo "Java CI/CD Pipeline FAILED"
        }
        always {
            echo "Pipeline finished"
        }
    }
}
