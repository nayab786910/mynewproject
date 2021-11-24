pipeline {
  agent{ label 'demo'}
    environment {
        registry = "519852036875.dkr.ecr.us-east-1.amazonaws.com/my-first-ecr"
    }
  stages{
    stage('clone repo'){
        steps{
         echo 'going to checkout the git'
        	git branch: 'master', url: 'https://github.com/nayab786910/mynewproject.git'
        	echo 'completed checkout the git'
        }
    }
    stage('build'){
       steps{
          echo 'build '
          sh "mvn clean package"
       }
   }
   stage ('code coverage') {
     steps {
      echo 'Running code coverage'
      sh "mvn org.jacoco:jacoco-maven-plugin:0.5.5.201112152213:prepare-agent"
     }
   }
   stage ('sonar analysis') {
        steps {
         withSonarQubeEnv('defaultsonar'){
          sh 'mvn sonar:sonar'
          } 
        }
  }
  stage("Quality Gate"){ 
    steps{
	       script {
	          timeout(time: 10, unit: 'MINUTES') { 
            def qg = waitForQualityGate() 
            if (qg.status != 'OK') {
              error "Pipeline aborted due to quality gate failure: ${qg.status}"
            }
         }
	    }
    }
  }
  stage('Stage Artifacts') 
  {          
   steps {          
    script { 
	    /* Define the Artifactory Server details */
        def server = Artifactory.server 'Jfrog'
        def uploadSpec = """{
            "files": [{
            "pattern": "target/myspringbootapp.jar.original", 
            "target": "Demo"                   
            }]
        }"""
        
        /* Upload the war to  Artifactory repo */
        server.upload(uploadSpec)
    }
   }
  }
  stage('Build Image') 
  {
    agent { label 'demo' }
    steps{
      script {
          myImage = docker.build registry
      }
    }
  }
  stage('Pushing to ECR') {
      agent { label 'demo'}
     steps{  
         script {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 519852036875.dkr.ecr.us-east-1.amazonaws.com'
                sh 'docker push 519852036875.dkr.ecr.us-east-1.amazonaws.com/my-first-ecr:latest'
         }
      }
  }
  stage ('K8S Deploy') {
      
      steps { 
                kubernetesDeploy(
                    configs: 'springboot.yaml',
                    kubeconfigId: 'K8s',
                    enableConfigSubstitution: true
                    )               
  
      }  
    }
  
 }
}
