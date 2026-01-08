#!/bin/bash

RECREATE_FLAG=""
IDE_VALUE="vscode"

while [[ $# -gt 0 ]]; do
  case "$1" in
  --recreate)
    RECREATE_FLAG="--recreate"
    shift
    ;;
  --ide)
    IDE_VALUE="$2"
    shift 2
    ;;
  *)
    shift
    ;;
  esac
done

if command -v devpod-cli >/dev/null 2>&1; then
  DEVPOD_BIN="devpod-cli"
elif command -v devpod >/dev/null 2>&1; then
  DEVPOD_BIN="devpod"
else
  echo "error: devpod binary not found in PATH (expected devpod-cli or devpod)" >&2
  exit 1
fi

export COMPOSE_PROJECT_NAME=$(basename "$PWD")

"$DEVPOD_BIN" context set-options default \
  -o SSH_INJECT_GIT_CREDENTIALS=false \
  -o SSH_INJECT_DOCKER_CREDENTIALS=false \
  -o GPG_AGENT_FORWARDING=false
CMD=("$DEVPOD_BIN" up . --ide "$IDE_VALUE")
[[ -n "$RECREATE_FLAG" ]] && CMD+=("$RECREATE_FLAG")
"${CMD[@]}"
