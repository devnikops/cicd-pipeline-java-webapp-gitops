pipeline {
    agent {
        label 'QA'
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
                    def artifactUrl = "${NEXUS_URL}/repository/maven-releases/${ARTIFACT_NAME}/${ARTIFACT_VERSION}/${ARTIFACT_NAME}-${ARTIFACT_VERSION}.${ARTIFACT_EXTENSION}"
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
                    withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIAL_ID, keyFileVariable: 'SSH_KEY_PATH', passphraseVariable: '', usernameVariable: 'SSH_USER')]) {
                        sshagent(['SSH_KEY_PATH']) {
                            sh "scp ${ARTIFACT_NAME}-${ARTIFACT_VERSION}.${ARTIFACT_EXTENSION} ${SSH_USER}@${HOST}:${DEPLOY_DIR}"
                        }
                    }
                }
            }
        }
    }
}
