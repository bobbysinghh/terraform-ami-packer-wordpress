pipeline{
    agent { 
        label "master"
    }
    parameters {
        string(name: 'ACCESS_KEY', description: 'aws access key of your aws account')
        string(name: 'SECRET_KEY', description: "aws secret key of aws account")
        string(name: 'DESIRED_SIZE', description: 'Desired Size of instances in auto scaling group')
        string(name: 'MAX_SIZE',description: "Maximum size of auto scaling group")
        string(name: 'MIN_SIZE',description: "Minimum size of auto scaling group")
    }
    stages{
        stage("packer-build"){
            steps{
                echo "Build Started"
                git branch: 'main', url: 'https://github.com/Bobby8249/terraform-ami-packer-wordpress.git'
                sh "export AWS_ACCESS_KEY_ID=${params.ACCESS_KEY}"
                sh "export AWS__SECRET_ACCESS_ID=${params.SECRET_KEY}"
                sh "sudo chmod 600 ./Packer/bobby_devops.pem"
            }
        stage("Terraform init"){
            steps{
                sh "terraform init"
            }
        }
        stage("Terraform Plan"){
            steps{
                sh "terraform plan"
            }
        }
        stage("Terraform Apply"){
            steps{
                sh "terraform apply --auto-approve \
                   -var asg_min_capacity=${params.MIN_SIZE} \
                   -var asg_max_capacity=${params.MAX_SIZE} \
                   -var asg_desired_capacity=${params.DESIRED_SIZE}"
            }
            post{
                success{
                    echo "executed successfully"
                }
                failure{
                    echo "execution failed"
                }
            }
        }
    }
}
