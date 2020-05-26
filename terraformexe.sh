     node{
         stage('Deploy') {
        withCredentials([azureServicePrincipal('Azure_credentials')]) {
            sh 'az login --service-principal -u $Client ID -p $Client Secret -t $Tenant ID'
            sh 'az account set -s $Subscription ID'
            sh 'az resource list'
            }
        }
   }
