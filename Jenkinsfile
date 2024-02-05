pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1' 
        AWS_CREDENTIALS = credentials('packer')  
    }

    stages {
        stage('Build AMI with Packer') {
            steps {
                script {
                    // Checkout source code from version control (replace with your VCS)
                    git branch: 'main', url: 'https://github.com/ryb9696/demo-packer.git'

                    // Install jq
                    sh 'apt-get update && apt-get install -y jq'

                    // Build AMI with Packer
                    sh 'packer build -var-file=vars.json template.json'
                    
                    // Fetch the AMI ID from the Packer manifest
                    def amiId = sh(script: 'cat manifest.json | jq -r \'.builds[0].artifact_id\' | awk -F\':\' \'{print $NF}\' | tr -d \'"\'', returnStdout: true).trim()
                    
                    // Store the AMI ID as an environment variable
                    env.PACKER_AMI_ID = amiId

                    // Print the AMI ID for logging purposes
                    echo "Packer AMI ID: $amiId"
                }
            }
        }

        stage('Create Launch Template with Terraform') {
            steps {
                script {
                    // Execute Terraform to create a Launch Template
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve -var "ami_id=${env.PACKER_AMI_ID}"'
                }
            }
        }
    }

}
