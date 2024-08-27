# 2024-08-27    21:36
=====================


**Create SharedLib for this project (Documentation).**
@Library(['JenkinsTesLib', 'jenkinslib@master'])

DeployToMaster(anyparam: "anyvalue")



**Add vulnerability scanning for docker images using Trivy.**
stage('Scan Docker Image for Vulnerabilities') {
    steps {
        script {
            def vulnerabilities = sh(script: "trivy image --exit-code 0 --severity HIGH,MEDIUM,LOW --no-progress ${registry}:${env.BUILD_ID}", returnStdout: true).trim()
            echo "Vulnerability Report:\n${vulnerabilities}"
        }
    }
}



**Add additional check for docker file using 'hadolint' before build stage.**
https://github.com/hadolint/hadolint
