#!/usr/bin/env bash
# Build a Docker image for a variant folder under docker dir. Give as argument name of that variant dir.
# Usage: ./scripts/build.sh <variant-folder-name> <tag>
# Example: ./scripts/build.sh ubuntu-22.04 Okt25

set -euo pipefail

VARIANT="${1:-ubuntu-22.04}"   # folder under docker/
TAG="${2:-latest}"             # image tag
IMAGE_NAME="yocto-${VARIANT}"  # base name for image
CONTEXT="docker/${VARIANT}"    # build context path
DOCKERFILE="${CONTEXT}/Dockerfile"

# Validate Dockerfile exists
if [[ ! -f "${DOCKERFILE}" ]]; then
    echo "Error: Dockerfile not found at ${DOCKERFILE}" >&2
    exit 1
fi

echo "Building image: ${IMAGE_NAME}:${TAG}"
echo "Context: ${CONTEXT}"
echo "Dockerfile: ${DOCKERFILE}"

docker build \
    --no-cache \
    --file "${DOCKERFILE}" \
    --tag "${IMAGE_NAME}:${TAG}" \
    --build-arg IMAGE_VERSION="${TAG}" \
    "${CONTEXT}"
