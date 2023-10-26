pipeline {
    agent any

   parameters {
        string(name:"Person", defaultValue:"Sreekanth", description:"")
    }
    stages {
        stage ("build"){
            steps{
                echo "my name is $Person"
            }
        }
    }
}
