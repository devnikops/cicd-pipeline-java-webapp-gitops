pipeline {
    agent any
    
    environment {
        NEXUS_URL = 'http://your-nexus-url.com' // Update with your Nexus URL
        NEXUS_REPO = 'your-nexus-repository'     // Update with your Nexus repository name
        ARTIFACT_ID = 'your-artifact-id'         // Update with your artifact ID
        GROUP_ID = 'your-group-id'               // Update with your artifact group ID
        VERSION = '1.0.0'                        // Update with your artifact version
        GITHUB_REPO = 'your-github-repo'         // Update with your GitHub repository name
        GITHUB_USERNAME = 'your-github-username' // Update with your GitHub username
        GITHUB_TOKEN = credentials('github-token') // Create Jenkins credential for GitHub token
    }
    
    stages {
        stage('Download Artifact') {
            steps {
                script {
                    def artifactUrl = "${NEXUS_URL}/repository/${NEXUS_REPO}/${GROUP_ID.replace('.', '/')}/${ARTIFACT_ID}/${VERSION}/${ARTIFACT_ID}-${VERSION}.jar"
                    sh "wget ${artifactUrl}"
                }
            }
        }
        
        stage('Upload to GitHub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                        sh "git clone https://${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${GITHUB_REPO}.git"
                        sh "cp ${ARTIFACT_ID}-${VERSION}.jar ${GITHUB_REPO}/" // Copy artifact to GitHub repository
                        sh "cd ${GITHUB_REPO} && git add . && git commit -m 'Add artifact' && git push origin master"
                    }
                }
            }
        }
    }
}
