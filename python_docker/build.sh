#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="python_docker"
VERSION="3.12"
PYTHON_VARIANT="${PYTHON_VARIANT:-bullseye}"
PLATFORMS="${PLATFORM:-linux/amd64,linux/arm64}"
LOCAL_TAG="evertri/${IMAGE_NAME}:${VERSION}"
REMOTE_TAG="ghcr.io/evertri/evertri-docker/${IMAGE_NAME}:${VERSION}"
BUILDX_BUILDER="${BUILDX_BUILDER:-evertri-multiarch}"

ensure_builder() {
  if ! docker buildx inspect "$BUILDX_BUILDER" >/dev/null 2>&1; then
    docker buildx create --name "$BUILDX_BUILDER" --driver docker-container >/dev/null
  fi

  docker buildx inspect --bootstrap "$BUILDX_BUILDER" >/dev/null
}

if [[ -n ${CR_USER:-} && -n ${CR_PAT:-} ]]; then
  echo "$CR_PAT" | docker login ghcr.io -u "$CR_USER" --password-stdin
  ensure_builder

  docker buildx build \
    --builder "$BUILDX_BUILDER" \
    --platform "$PLATFORMS" \
    --build-arg "PYTHON_VERSION=$VERSION" \
    --build-arg "PYTHON_VARIANT=$PYTHON_VARIANT" \
    --push \
    -t "$REMOTE_TAG" \
    "$SCRIPT_DIR"
else
  echo "CR_USER, CR_PAT 환경변수가 없어 이미지를 로컬에서만 빌드합니다."
  IFS=',' read -r -a platform_list <<< "$PLATFORMS"

  for platform in "${platform_list[@]}"; do
    platform_tag="$LOCAL_TAG"
    if [[ "$platform" != "linux/amd64" ]]; then
      platform_tag="${LOCAL_TAG}-${platform//\//-}"
    fi

    docker buildx build \
      --platform "$platform" \
      --build-arg "PYTHON_VERSION=$VERSION" \
      --build-arg "PYTHON_VARIANT=$PYTHON_VARIANT" \
      --load \
      -t "$platform_tag" \
      "$SCRIPT_DIR"
  done
fi
