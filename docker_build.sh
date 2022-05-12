#!/bin/bash

BUILD_NO="${BUILD_NUMBER:-1}"
DOCKER_BUILD_TARGET="${DOCKER_BUILD_TARGET:-compile}"
DOCKER_IMAGE_TAG="${DOCKER_IMAGE_TAG:-soti-signal:$BUILD_NO}"
DOCKER_TEST_OUTPUT_PATH="${TEST_COVERAGE_OUTPUT_DIRECTORY:-/app/dist}"

DOCKER_CONTAINER_FILE="/tmp/docker_${BUILD_NO}.cid"

echo "DOCKER_BUILD_TARGET:${DOCKER_BUILD_TARGET}"
echo "DOCKER_IMAGE_TAG:${DOCKER_IMAGE_TAG}"
echo "DOCKER_CONTAINER_FILE:${DOCKER_CONTAINER_FILE}"

DOCKER_BUILD_ARGS="build --no-cache --target ${DOCKER_BUILD_TARGET} --tag ${DOCKER_IMAGE_TAG} ."
DOCKER_RUN_ARGS="run -d -it --cidfile ${DOCKER_CONTAINER_FILE} ${DOCKER_IMAGE_TAG} pwd"

# Checking whether dockerfile exist in same folder or not
if [ ! -f "dockerfile" ]; then
	echo "Error: dockerfile not found at $(pwd)"
	exit 1
fi

# Building docker image
#sudo DOCKERBUILDKIT=1 docker ${DOCKER_BUILD_ARGS}
ret=$?
if [ $ret -ne 0 ]; then
	echo "Error: Encountered error while building Docker Image."
	exit 1
fi

# Running docker container
#sudo DOCKERBUILDKIT=1 docker ${DOCKER_RUN_ARGS}
ret=$?
if [ $ret -ne 0 ]; then
	echo "Error: Encountered error while running Docker Container."
	exit 1
fi

# Returning if Docker target is only to compile the source code.
if [ "$DOCKER_BUILD_TARGET" == "compile" ]; then
	exit 0
fi

# Copying Test Output From Docker Container
if [ ! -f ${DOCKER_CONTAINER_FILE} ]; then
	echo "Error: Docker Container id file ${DOCKER_CONTAINER_FILE} not found."
	exit 1
fi

#DOCKER_CONTAINER_ID=$(sudo cat ${DOCKER_CONTAINER_FILE})
if [[ -z ${DOCKER_CONTAINER_ID} ]; then
	echo "Error: Docker Container id not found."
	exit 1
fi

echo "DOCKER_CONTAINER_ID:${DOCKER_CONTAINER_ID}"

#DOCKER_COPY_ARGS="cp ${DOCKER_CONTAINER_ID}:${DOCKER_TEST_OUTPUT_PATH} ./"
#sudo docker ${DOCKER_COPY_ARGS}
ret=$?
if [ $ret -ne 0 ]; then
	echo "Error: Encountered error while copying files from Docker Container."
	exit 1
fi

exit 0