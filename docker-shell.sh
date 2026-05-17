#!/usr/bin/env bash
set -euo pipefail

image_name="${COMFY_DOCKER_IMAGE:-linux-comfy-chair-dev}"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
log_file=""

case "${1:-}" in
  "")
    ;;
  --log)
    log_file="logs/docker-session-$(date +%Y%m%d-%H%M%S).log"
    mkdir -p "$script_dir/logs"
    echo "Logging container session to $log_file"
    ;;
  *)
    echo "Usage: $0 [--log]"
    exit 2
    ;;
esac

docker build \
  --build-arg USER_UID="$(id -u)" \
  --build-arg USER_GID="$(id -g)" \
  --tag "$image_name" \
  "$script_dir"

echo "Starting disposable Ubuntu test container. Exit the shell to remove it."
set +e
if [ -n "$log_file" ]; then
  docker run \
    --rm \
    --interactive \
    --tty \
    --mount "type=bind,src=${script_dir},target=/home/comfy/comfy-chair" \
    "$image_name" 2>&1 | tee "$script_dir/$log_file"
  status=${PIPESTATUS[0]}
else
  docker run \
    --rm \
    --interactive \
    --tty \
    --mount "type=bind,src=${script_dir},target=/home/comfy/comfy-chair" \
    "$image_name"
  status=$?
fi
set -e
echo "Disposable container removed."
exit "$status"
