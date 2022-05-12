pipeline{
	agent { label "CentOS7" }
	options{
		buildDiscarder(logRotator(numToKeepStr: '10'))
		timeout(time:1, unit: 'HOURS')
		timestamps()
	}
	environment{
		BUILD_SCRIPT_PATH = 'docker_build.sh'
		DOCKER_BUILD_TARGET = 'compile'
		DOCKER_IMAGE_TAG = "soti-signal:${env.BUILD_NUMBER}"
	}
	stages{
		stage('Compile')
		{
			steps{				
				sh(
					label: 'Docker NPM Build',
					script: """
						chmod -R 755 ${env.WORKSPACE}/${env.BUILD_SCRIPT_PATH}
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