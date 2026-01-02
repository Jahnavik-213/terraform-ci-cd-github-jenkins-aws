
## Jenkinsfile

```groovy
pipeline {
    agent any
    
    parameters {
        choice(
            name: 'TerraformAction',
            choices: ['apply', 'destroy', 'plan'],
            description: 'Terraform action'
        )
    }
    
    environment {
        AWS_REGION     = 'us-east-1'
        TF_VERSION     = '1.5.0'
        TERRAFORM_DIR  = 'terraform'
        STATE_BUCKET   = 'your-terraform-state-bucket'  // Create this S3 bucket
        STATE_KEY      = 'devops-demo/terraform.tfstate'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') { 
            steps {
                dir(TERRAFORM_DIR) { #Changes the working dir inside the Jenkins workspace
                    sh '''
                    terraform init \
                      -backend-config="bucket=${STATE_BUCKET}" \
                      -backend-config="key=${STATE_KEY}" \
                      -backend-config="region=${AWS_REGION}"
                    '''
                }
            }
        }
        
        stage('Terraform Plan') {
            when {
                not { equal expected: 'destroy', actual: params.TerraformAction }
            }
            steps {
                dir(TERRAFORM_DIR) {
                    script {
                        def planFile = "tfplan-${BUILD_NUMBER}" #creates a unique terraform plan file with build number
                        sh """ 
                        terraform plan \
                          -var-file="terraform.tfvars" \
                          -out=${planFile} \
                          -no-color
                        """ #Excecute Linux Shell commands
			#triple quotes allow multi-line commands

                        archiveArtifacts artifacts: planFile #store TF plan file in jenkins
                    }
                }
            }
        }
        
        stage('Terraform Apply Approval') {
            when {
                expression { params.TerraformAction == 'apply' }
            }
            steps {
                input message: 'Apply this plan?', 
                      parameters: [choice(name: 'CONFIRM', choices: ['YES', 'NO'])]
            }
        }
        
        stage('Terraform Action') {
            steps {
                dir(TERRAFORM_DIR) {
                    script {
                        if (params.TerraformAction == 'apply') {
                            sh 'terraform apply -auto-approve tfplan-${BUILD_NUMBER}'
                        } else if (params.TerraformAction == 'destroy') {
                            input message: 'Destroy infrastructure?'
                            sh 'terraform destroy -auto-approve'
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            dir(TERRAFORM_DIR) {
                sh 'terraform show || true'
            }
        }
        success {
            echo '✅ Infrastructure deployed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check Terraform plan above.'
        }
    }
}
