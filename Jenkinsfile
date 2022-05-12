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
				checkout scm
				stash includes: "**", name: 'SourceCode'
			}
		}
		stage('Compile')
		{
			agent { label "CentOS7" }
			options{
				skipDefaultCheckout()
			}
			steps{				
				cleanWs()
				unstash 'SourceCode'
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