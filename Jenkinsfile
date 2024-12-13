pipeline {
    agent {
        label "hcloud-docker-x86"
    }
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
                    branches: [[name: 'refs/heads/main']],
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

                sh "env"
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
                    sh "docker container cp blink1-tool_builder:/usr/local/src/dist/ ."
                    env.VERSION = readFile('dist/blink1_version.txt').trim()
                    env.DEBFILE = readFile('dist/debfile.txt').trim()
                    currentBuild.description = env.VERSION
                    stash(name: "agent", includes: "dist/")
                }
            }
        }
    }

    post {
        success {
            script {
                unstash(name: "agent")
                archiveArtifacts(artifacts: "dist/${env.DEBFILE}", fingerprint: true)

                // def timer = currentBuild.getBuildCauses()[0]["shortDescription"].matches("Started by timer")
                // if (!fileExists("${env.JENKINS_HOME}/artifacts/${env.DEBFILE}}")) {
                // }

                sh "cp dist/${env.DEBFILE} ${env.JENKINS_HOME}/artifacts"

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
            sh "ls -lah"
            cleanWs(
                deleteDirs: true,
                //patterns: [[pattern: 'blink1-tool-web', type: 'EXCLUDE']],
                disableDeferredWipeout: true,
                notFailBuild: true
            )
            sh "docker container rm blink1-tool_builder || true"
        }
    }
}
