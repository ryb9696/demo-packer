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
                    git branch: 'main', url: 'https://github.com/your/repo.git'

                    // Build AMI with Packer
                    sh 'packer build -var-file=packer-vars.json packer-template.json'
                    
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
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }

    post {
        always {
            // Clean up: Destroy resources (e.g., terminate instances) after the pipeline
            script {
                // Destroy Terraform resources
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}
