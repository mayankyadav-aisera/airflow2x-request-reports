@Library(value = 'devops@master', changelog = false) _

def AISERA_TAG = "UNKNOWN"

pipeline {
  agent any

  environment {
    GIT_REPO = 'https://github.com/mayankyadav-aisera/airflow2x-request-reports.git'
    ARTIFACTORY_SERVER_ID = 'request_report'
    ARTIFACTORY_REPO = 'https://${JFROG_USER}:${JFROG_PASSWORD}@aisera.jfrog.io/artifactory/'
    CREDENTIALS_ID = 'db7cd3c3-ea63-4889-b54e-040b8e012ab5'
  }

  stages {
    stage('Checkout') {
        steps {
            git url : "${GIT_REPO}", credentialsId: "${CREDENTIALS_ID}"
        }
    }

    stage('Upload to Artifactory') {
        steps {
            script {
                def server = Artifactory.server "${ARTIFACTORY_SERVER_ID}"
                def uploadSpec = """{
                    "files": [{
                        "pattern" : "airflow2x-request-reports/request_report_scripts",
                        "target": "${ARTIFACTORY_REPO}/request-reports/request_report_scripts"
                    }]
                }"""
                server.upload(uploadSpec)
            }
        }
    }
  }