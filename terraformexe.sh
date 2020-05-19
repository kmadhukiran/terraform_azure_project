pipeline {
   agent any

   stages {
      stage('Github creadintials') {
         steps {
            git credentialsId: 'Atmecs', url: 'https://github.com/kmadhukiran/terraform_azure_project.git'
         }
      }
         stage('Build_terraform') {
         steps {
            sh label: '', script: 'terraform init '
         }
      }
      stage('terraform_plan') {
         steps {
            sh label: '', script: 'terraform plan'
         }
      }
      stage('terraform_apply') {
         steps {
            sh label: '', script: 'terraform apply --auto-approve'
         }
      }
   }
}
