#!/usr/bin/env bash
# Build and push a Docker image for the fork.
# Usage:
#   bash scripts/docker-build.sh              # build+push multi-arch :latest to $IMAGE
#   bash scripts/docker-build.sh v1.2.3        # build+push multi-arch with a custom tag
#   bash scripts/docker-build.sh --load        # build amd64-only and load into local docker (no push)
#
# Env overrides:
#   IMAGE=poomie/wealthfolio          # image repo to tag/push
#   PLATFORMS=linux/amd64,linux/arm64 # target platforms (ignored with --load)

set -euo pipefail

REPO_ROOT="$(git -C "$(dirname "${BASH_SOURCE[0]}")/.." rev-parse --show-toplevel)"
cd "$REPO_ROOT"

IMAGE="${IMAGE:-poomie/wealthfolio}"
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"
TAG="latest"
LOAD=false

for arg in "$@"; do
  case "$arg" in
    --load)
      LOAD=true
      ;;
    *)
      TAG="$arg"
      ;;
  esac
done

BUILDER=wealthfolio-builder
if ! docker buildx inspect "$BUILDER" >/dev/null 2>&1; then
  docker buildx create --name "$BUILDER" >/dev/null
fi
docker buildx use "$BUILDER"

GIT_SHA="$(git rev-parse --short=7 HEAD)"

ARGS=(
  build
  --builder "$BUILDER"
  --build-arg "GIT_SHA=${GIT_SHA}"
  -t "${IMAGE}:${TAG}"
  .
)

if [[ "$LOAD" == "true" ]]; then
  echo "=== building ${IMAGE}:${TAG} (linux/amd64, local load, no push) ===" >&2
  ARGS+=(--platform linux/amd64 --load)
else
  echo "=== building and pushing ${IMAGE}:${TAG} (${PLATFORMS}) ===" >&2
  ARGS+=(--platform "$PLATFORMS" --push)
fi

docker buildx "${ARGS[@]}"
