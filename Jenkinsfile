pipeline{
    agent {
        label 'slave'
    }
    
    stages{
        stage('checkout'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], 
                doGenerateSubmoduleConfigurations: false, 
                extensions: [[$class: 'CleanBeforeCheckout']], submoduleCfg: [], 
                userRemoteConfigs: [[credentialsId: 'gitcreds', url: 'https://github.com/raghavendar08/terraform']]])
            }
        }
    }
