#!/bin/bash
set -e

# source this file to set up environment for use by other scripts

DOCKER_REGISTRY_HOST="batdevcontainerregistry.azurecr.io"
DOCKER_REGISTRY_IMAGE="find-teacher-training"

export DOCKER_PATH="$DOCKER_REGISTRY_HOST/$DOCKER_REGISTRY_IMAGE"
