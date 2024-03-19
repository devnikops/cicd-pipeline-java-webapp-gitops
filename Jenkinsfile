pipeline {
    agent {
        label 'QA'          //jenkins-slave
    }
    
    environment {
        NEXUS_URL = 'http://13.232.79.166:8081'
        NEXUS_CREDENTIAL_ID = 'nexus'
        HOST = '43.205.17.24'
        SSH_CREDENTIAL_ID = 'jenkins-slave'
        ARTIFACT_VERSION = '0.0.1' // Update this with your artifact version
        ARTIFACT_NAME = 'MyLab' // Update this with your artifact name
        ARTIFACT_EXTENSION = 'war' // Update this with your artifact extension
        DEPLOY_DIR = '/opt/tomcat/webapps'
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
        
        stage('Deploy Artifact') {
            steps {
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIAL_ID, keyFileVariable: 'jenkins-slave', passphraseVariable: '', usernameVariable: 'SSH_USER')]) {
                        sshagent(['jenkins-slave']) {                           
                            echo "Artifact Path: ${ARTIFACT_NAME}-${ARTIFACT_VERSION}.${ARTIFACT_EXTENSION}"
                            echo "Deployment Directory: ${SSH_USER}@${HOST}:${DEPLOY_DIR}"
                            echo "Deploying ${ARTIFACT_NAME}-${ARTIFACT_VERSION}.${ARTIFACT_EXTENSION} to ${SSH_USER}@${HOST}:${DEPLOY_DIR}"
                            sh "ssh-keyscan -H 43.205.17.24 >> ~/.ssh/known_hosts"
                            sh "scp ${ARTIFACT_NAME}-${ARTIFACT_VERSION}.${ARTIFACT_EXTENSION} ${SSH_USER}@${HOST}:${DEPLOY_DIR} || exit 1"
                        }
                    }
                }
            }
        }
    }
}
