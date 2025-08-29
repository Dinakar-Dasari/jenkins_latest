pipeline {
    agent {
        label 'agent-1'
    }
    tools {
        nodejs 'nodejs-20'
    }

    stages{
        stage('git checkout') {
            steps{ 
                git branch: 'main', url: 'https://github.com/Dinakar-Dasari/jenkins_latest.git'
            }   
        }

        stage('install dependencies') {
            steps{
                sh 'npm install'
            }
        }

        stage('test') {
            steps{
                echo "run test cases"
            }
        }

        stage("dependency scan") {
            steps{
                dependencyCheck additionalArguments: '''
                   --scan ./ 
                   --format 'ALL' 
                   --prettyPrint 
                ''',
                odcInstallation: 'owsap-dependency'
                // dependencyCheckPublisher pattern: 'OWSAP_catalogue.xml'
            }
        }

    }

    post { 
    always { 
        echo 'I will always say Hello again!'
        deleteDir() // --> this will delete the files in workspace directory in agent
    }
    }
}