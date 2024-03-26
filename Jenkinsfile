pipeline {
    agent {
        label 'QA'          //jenkins-slave
    }
    
    environment {
        NEXUS_URL = 'http://13.232.79.166:8081'
        NEXUS_CREDENTIAL_ID = 'nexus'
        HOST = '43.205.17.24'
        SSH_CREDENTIAL_ID = 'jenkins-slave'
        ARTIFACT_VERSION = '0.0.1' 
        ARTIFACT_NAME = 'MyLab' 
        ARTIFACT_EXTENSION = 'war'
        DEPLOY_DIR = '/opt/tomcat/webapps'

        GITHUB_REPO = 'cicd-pipeline-java-webapp-gitops'
        GITHUB_USERNAME = 'devnikops'
        GITHUB_USEREMAIL = 'nikks.geeks@gmail.com'
        GITHUB_TOKEN = credentials('Jenkins-Github-token')
        
        APP_NAME = "mylab"
        RELEASE = "0.0.1"
        DOCKER_USER = "nikhil999999"
        DOCKER_PASS = 'docker-jenkins'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }
    
    stages {
        stage('Fetch Artifact') {
            steps {
                script {
                    def artifactUrl = "${NEXUS_URL}/repository/MyLab-RELEASE/com/mylab/${ARTIFACT_NAME}/${ARTIFACT_VERSION}/${ARTIFACT_NAME}-${ARTIFACT_VERSION}.${ARTIFACT_EXTENSION}"
                    def artifactFile = "${ARTIFACT_NAME}-${ARTIFACT_VERSION}.${ARTIFACT_EXTENSION}"
                    
                    withCredentials([usernamePassword(credentialsId: NEXUS_CREDENTIAL_ID, usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASSWORD')]) {
                        sh "curl -u ${NEXUS_USER}:${NEXUS_PASSWORD} -O ${artifactUrl}"
                    }
                }
            }
        }
        
        stage('Deploy Artifact on QA System') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIAL_ID, keyFileVariable: 'jenkins-slave', passphraseVariable: '', usernameVariable: 'SSH_USER')]) {
                        sshagent(['jenkins-slave']) {                           
                            echo "Artifact Path: ${ARTIFACT_NAME}-${ARTIFACT_VERSION}.${ARTIFACT_EXTENSION}"
                            echo "Deployment Directory: ${SSH_USER}@${HOST}:${DEPLOY_DIR}"
                            echo "Deploying ${ARTIFACT_NAME}-${ARTIFACT_VERSION}.${ARTIFACT_EXTENSION} to ${SSH_USER}@${HOST}:${DEPLOY_DIR}"
                            /* sh "ssh-keyscan -H 43.205.17.24 >> ~/.ssh/known_hosts" */
                            sh "scp ${ARTIFACT_NAME}-${ARTIFACT_VERSION}.${ARTIFACT_EXTENSION} ${SSH_USER}@${HOST}:${DEPLOY_DIR} || exit 1"                           
                        }
                    }
                }
            }
        }

        stage("Upload War to GitHub") {
            steps {
                script {
                    withCredentials([gitUsernamePassword(credentialsId: 'Jenkins-Github-token', gitToolName: 'Default')]) {
                        sh """
                            git config --global user.email "${GITHUB_USEREMAIL}"
                            git config --global user.name "${GITHUB_USERNAME}"
                            git clone https://github.com/${GITHUB_USERNAME}/${GITHUB_REPO}
                            cd ${GITHUB_REPO}
                            mv ../*.war .
                            git add *.war
                            git commit -m "Add *.war"
                            git push origin main
                        """
                    }
                }
            }
        }

        stage("Build & Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')     
                    }
                }
            }
        } 
    }
}
