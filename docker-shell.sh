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
  raw_log="$script_dir/$log_file.raw"
  docker run \
    --rm \
    --interactive \
    --tty \
    --mount "type=bind,src=${script_dir},target=/home/comfy/comfy-chair" \
    "$image_name" 2>&1 | tee "$raw_log"
  status=${PIPESTATUS[0]}
  perl -MTerm::ANSIColor=colorstrip -pe '$_ = colorstrip($_); s/\e\[[0-?]*[ -\/]*[@-~]//g; s/\e\][^\a]*(?:\a|\e\\)//g; s/\e[ -\/]*[0-~]//g; 1 while s/[^\n]\x08//g; s/\r//g; s/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]//g' "$raw_log" > "$script_dir/$log_file"
  rm -f "$raw_log"
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
