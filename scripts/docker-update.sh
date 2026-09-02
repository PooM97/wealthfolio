#!/usr/bin/env bash
# Start or update the self-hosted Wealthfolio container from a pre-built image.
# Pulls the latest image and recreates the container if it changed.
#
# Usage:
#   bash scripts/docker-update.sh              # pull + up -d via compose.fork.yml
#   bash scripts/docker-update.sh --prune       # also remove dangling images after update
#
# Env overrides:
#   ENV_FILE=.env.docker    # compose --env-file
#   OVERLAY=compose.fork.yml

set -euo pipefail

REPO_ROOT="$(git -C "$(dirname "${BASH_SOURCE[0]}")/.." rev-parse --show-toplevel)"
cd "$REPO_ROOT"

ENV_FILE="${ENV_FILE:-.env.docker}"
OVERLAY="${OVERLAY:-compose.fork.yml}"
PRUNE=false

for arg in "$@"; do
  case "$arg" in
    --prune)
      PRUNE=true
      ;;
    *)
      echo "Usage: scripts/docker-update.sh [--prune]" >&2
      exit 2
      ;;
  esac
done

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing $ENV_FILE — see compose.yml header for required vars (e.g. WF_SECRET_KEY)." >&2
  exit 1
fi

COMPOSE=(docker compose --env-file "$ENV_FILE" -f compose.yml -f "$OVERLAY")

echo "=== pulling latest image ===" >&2
"${COMPOSE[@]}" pull

echo "=== starting/recreating container ===" >&2
"${COMPOSE[@]}" up -d

if [[ "$PRUNE" == "true" ]]; then
  echo "=== pruning dangling images ===" >&2
  docker image prune -f
fi

echo "=== status ===" >&2
"${COMPOSE[@]}" ps
