pipeline {
    agent {
        label 'agent-1'
    }
    tools {
        nodejs 'nodejs-20'
    }

    environment {
        SONAR_SCANNER_HOME = tool 'sonar-7.2';
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
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml', stopBuild: false
                // by default the build will not fail if we don't give failedTotalMedium: 1, stopBuild: true
            }
        }

        stage('sonar') {
              steps{
                timeout(time: 60, unit: 'SECONDS') {
                        withSonarQubeEnv('sonar-server') {
                        sh '''
                            $SONAR_SCANNER_HOME/bin/sonar-scanner 
                            -Dsonar.projectKey=catalogue \
                            -Dsonar.sources=server.js
                            '''
                        }

                        
                     waitForQualityGate abortPipeline: true  
                }      
              }
        }

    }

    post { 
    always { 
        echo 'I will always say Hello again!'
       // deleteDir() // --> this will delete the files in workspace directory in agent
    }
    }
}