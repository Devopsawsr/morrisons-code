pipeline {
    agent {label "mnp-dev-app-agent"}
    tools {
        jdk "java17"
        maven "maven3"
    }
    stages {
        stage ("checkscm") {
            steps {
                checkout scm
            }
        }
        stage ("Build") {
            steps {
                sh "mvn clean package"
            }
        }
        stage ("Test") {
            steps {
                sh "mvn test"
            }
        }
    }
}
 