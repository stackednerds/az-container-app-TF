pipeline {
    agent any
    parameters {
        choice(name: "action", choices: ['plan','destroy'])
    }
    environment {
        TFVARS_PASSPHRASE = credentials('gpg-passphrase')
        APP_NAME = "azure-web-search"
    }
    stages {
        stage ('TF Initialising') {
            steps {
                script {
                    sh "terraform init"
                }
            }
        }
        stage ('decrypting the tfvars file') {
            steps {
                script {
                    sh "gpg --batch --yes --passphrase $TFVARS_PASSPHRASE -d terraform.tfvars.gpg > terraform.tfvars"
                }
            }
        }
        stage ('changing the image name') {
            steps {
                script {
                    sh """
                    sed -i 's|^image_name = \".*\"|image_name = \"amitsingh01/${APP_NAME}:${IMAGE_TAG}\"|' terraform.tfvars
                    """
                }
            }
        }
        stage ('TF Plan') {
            steps {
                script {
                    sh "terraform ${params.action}"
                }
            }
        }
        stage ('Removing the tfvars file') {
            steps {
                script {
                    sh "rm -rf terraform.tfvars"
                }
            }
        }
    }
    post { 
        always { 
            cleanWs()
        }
    }
}
