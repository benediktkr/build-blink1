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
        stage('Clone') {
            steps {
                sh "env"

                echo "Clone repo to '${env.WORKSPACE}'.."
                checkout scm

                echo "Clone 'blink1-tool.repo' to '${env.WORKSPACE}/blink1-tool'..."
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
            }
        }
        stage('Build') {
            steps {
                sh "docker build --pull -t blink1-tool-builder ."
                sh "docker container create --name blink1-tool_builder blink1-tool-builder"
                sh "docker container cp blink1-tool_builder:/usr/local/src/dist/ ."
            }
            post {
                always {
                    script {
                        env.VERSION = readFile('dist/blink1_version.txt').trim()
                        env.DEBFILE = readFile('dist/debfile.txt').trim()
                        currentBuild.description = env.VERSION
                    }
                }
                success {
                    stash(name: "agent", includes: "dist/")
                    cleanWs(deleteDirs: true, notFailBuild: true)
                }
                cleanup {
                    sh "docker container rm blink1-tool_builder"
                }
            }
        }
        stage('Upload') {
            agent {
                // its also possible to wrap steps in :
                //
                // steps { node('built-in') { ... } }
                label "built-in"
            }
            steps {
                unstash(name: "agent")

                sh "cp -v dist/${env.DEBFILE} ${env.JENKINS_HOME}/artifacts/${env.DEBFILE}"
                sh "du -sh ${env.JENKINS_HOME}/artifacts/${env.DEBFILE}"
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
            post {
                success {
                    archiveArtifacts(artifacts: "dist/${env.DEBFILE}", fingerprint: true)
                }
                cleanup {
                    sh "rm -v ${env.JENKINS_HOME}/artifacts/${env.DEBFILE}"
                    // The 'built-in' node only has the 'dist/' dir in it's workspace,
                    // since it was in the stash.
                    cleanWs(deleteDirs: true, notFailBuild: true)
                }
            }
        }
    }
}
