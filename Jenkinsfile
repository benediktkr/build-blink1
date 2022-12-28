pipeline {
    agent any
    options {
        timestamps()
        ansiColor("xterm")
        disableConcurrentBuilds()
        skipDefaultCheckout()
    }
    stages {
        stage('checkout') {
            steps{
                checkout scm

                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'refs/heads/master']],
                    extensions: [[
                        $class: 'RelativeTargetDirectory',
                        relativeTargetDir: 'blink1-tool'
                    ]],
                    doGenerateSubmoduleConfigurations: false,
                    // extensions: [[$class: 'CloneOption',
                    //               depth: 1, noTags: false, shallow: true]],
                    userRemoteConfigs: [[
                        url: 'https://git.sudo.is/mirrors/blink1-tool.git'
                    ]],
                ])
            }
        }

        stage ('build') {
            steps {
                sh "docker build --pull -t blink1-tool-builder ."
            }
        }
        stage('deb') {
            steps {
                script {
                    sh "docker container create --name blink1-tool_builder blink1-tool-builder"
                    sh "docker container cp blink1-tool_builder:/usr/local/dist/target/ ."
                    def debfile = sh "ls target/*.deb", returnStdout: true
                    currentBuild.description = "${debfile}"
                }
            }
        }
    }

    post {
        success {
            script {
                def debfile = currentBuild.description
                archiveArtifacts(
                    artifacts: 'target/' + debfile,
                    fingerprint: true
                )

                // def timer = currentBuild.getBuildCauses()[0]["shortDescription"].matches("Started by timer")
                // if (!fileExists("${env.JENKINS_HOME}/artifacts/${debfile}")) {
                // }

                sh "cp target/${debfile} ${env.JENKINS_HOME}/artifacts"

                build(
                    job: "/utils/apt",
                    wait: true,
                    propagate: true,
                    parameters: [[
                        $class: 'StringParameterValue',
                        name: 'filename',
                        value: "${debfile}"
                    ]])

            }
        }
        cleanup {
            cleanWs(
                deleteDirs: true,
                //patterns: [[pattern: 'blink1-tool-web', type: 'EXCLUDE']],
                disableDeferredWipeout: true,
                notFailBuild: true
            )
            script {
                sh "docker container rm blink1-tool_builder || true"
                sh "ls -lah"
            }
        }
    }
}
