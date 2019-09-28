pipeline{
    agent {
        label 'terra'
    }

    triggers{
        pollSCM('H/2 * * * *')
    }

    parameters{
        booleanParam (name: delete, defaultValue: false, description: 'for deleting')
        booleanParam (name: update, defaultValue: false, description: 'for updating')
    }

    options{
        disableConcurrentBuilds()
        timeout(180)
        buildDiscarder logRotator(numToKeepStr: '30')
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

        stage (validate){
            steps{
                sh 'cloudformation validate-template --template-body file://name.yaml --'
            }
        }
}
