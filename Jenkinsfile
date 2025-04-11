pipeline {
    agent { label 'jenkein-node' }

    environment {
        SONARQUBE_ENV = 'SonarQube'  // Ensure this matches your configuration name in Jenkins
        DOCKER_IMAGE_NAME = 'travelapp'  // Define your Docker image name
        DOCKER_TAG = 'latest'  // You can also use a version here like '1.0.0'
    }

    stages {
        stage('Clone') {
            steps {
                checkout scm
            }
        }

        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    sh 'sonar-scanner -Dsonar.login=sqp_7acb4420af8a71800e39c7dc75bc2859f985b55d'
                }
            }
        }
        

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile
                    sh 'sudo env DOCKER_BUILDKIT=0 docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} .'
                }
            }
        }
    }
}
