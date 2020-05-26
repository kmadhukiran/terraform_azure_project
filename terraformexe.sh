pipeline {
   agent any

   stages {
      stage('Github creadintials') {
         steps {
            git credentialsId: 'Atmecs', url: 'https://github.com/kmadhukiran/terraform_azure_project.git'
         }
      }
         node{
         stage('Deploy') {
        withCredentials([azureServicePrincipal('Azure_credentials')]) {
            sh 'az login --service-principal -u $Client ID -p $Client Secret -t $Tenant ID'
            sh 'az account set -s $Subscription ID'
            sh 'az resource list'
            }
        }
    }
}
}
