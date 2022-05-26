import groovy.transform.Field

@Field
String CommitHash = ""

pipeline{
	agent none
	options{
		buildDiscarder(logRotator(numToKeepStr: '10'))
		timeout(time:1, unit: 'HOURS')
		timestamps()
		skipDefaultCheckout()
	}
	environment{
		BUILD_SCRIPT_PATH = 'docker_build.sh'
		DOCKER_BUILD_TARGET = 'compile'
		DOCKER_IMAGE_TAG = "soti-signal:${env.BUILD_NUMBER}"
	}
	stages{
		stage('Checkout'){
			agent {label "master"}
			steps{
				cleanWs()
				script{
					commitdetails = checkout scm
					println commitdetails.dump()
					println commitdetails.GIT_COMMIT
					CommitHash = commitdetails.GIT_COMMIT.substring(0,6)
					println CommitHash
					env.DOCKER_IMAGE_TAG = "${env.DOCKER_IMAGE_TAG}:${env.BUILD_NUMBER}.${CommitHash}"
					stash includes: "**", name: 'SourceCode'
				}
			}
		}
		stage('Compile')
		{
			agent { label "Ubuntu2" }
			options{
				skipDefaultCheckout()
			}
			steps{
				cleanWs()
				unstash 'SourceCode'
				echo CommitHash
				sh(
					label: 'Docker NPM Build',
					script: """
						chmod -R 755 ${env.WORKSPACE}/${env.BUILD_SCRIPT_PATH}
						sed -i 's/\r//g' ${env.WORKSPACE}/dockerfile
						sed -i 's/\r//g' ${env.WORKSPACE}/${env.BUILD_SCRIPT_PATH}
						${env.WORKSPACE}/${env.BUILD_SCRIPT_PATH}
					"""
				)
			}
			post{
				always{
					script{
						sh """
							echo "Post"
						"""
					}
				}
			}
		}
	}
}
