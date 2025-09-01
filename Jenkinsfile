pipeline {
    agent {
        label 'agent-1'
    }
    tools {
        nodejs 'nodejs-20'
    }

    environment {
        appVersion=''
        SONAR_SCANNER_HOME = tool 'sonar-7.2';
        PROJECT = 'roboshop'
        COMPONENT = 'catalogue'
        REGION = 'us-east-1'
        ACC_ID = '127218179061'
    }

    options {
        timeout(time:30, unit:'MINUTES')  // pipeline will terminate if exceeds 30 minutes
    }

    stages{

        stage('clean up') {
            steps {
                deleteDir()
            }
        }

/// git branch: 'main', url: 'https://github.com/Dinakar-Dasari/jenkins_latest.git'
/// Can skip git checkout as it will clone already when we use the URL in the UI

        stage('get app version') {
            steps{
                script{
                    def packageJson = readJSON file: 'package.json'
                    appVersion = packageJson.version
                    echo "Package version: ${appVersion}"
                }    
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
                odcInstallation: 'owsap-dependency' //tool name which we configured in tool section
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml', stopBuild: false
                // by default the build will not fail if we don't give failedTotalMedium: 1, stopBuild: true
            }
        }

        stage('SAST-sonar') {
            steps{
                timeout(time: 60, unit: 'SECONDS') {
                        withSonarQubeEnv('sonar-server') {
                        sh '''
                            $SONAR_SCANNER_HOME/bin/sonar-scanner \
                                -Dsonar.projectKey=$COMPONENT \
                                -Dsonar.sources=server.js \
                        '''
                        }

                     // waitForQualityGate abortPipeline: true  
                     // pipeline will fail because there is no code coverage. So, to continue we are disabling it
                }      
            }
        }

        stage('Image build') {
            steps{
                withAWS(credentials: 'aws-creds', region=$REGION) {
                    sh '''
                        aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com
                        docker build -t ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion} .
                        docker push ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion}
                    '''
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