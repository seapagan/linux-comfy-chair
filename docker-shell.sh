#!/usr/bin/env bash
set -euo pipefail

image_name="${COMFY_DOCKER_IMAGE:-linux-comfy-chair-dev}"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

docker build \
  --build-arg USER_UID="$(id -u)" \
  --build-arg USER_GID="$(id -g)" \
  --tag "$image_name" \
  "$script_dir"

echo "Starting disposable Ubuntu test container. Exit the shell to remove it."
set +e
docker run \
  --rm \
  --interactive \
  --tty \
  --mount "type=bind,src=${script_dir},target=/home/comfy/comfy-chair" \
  "$image_name"
status=$?
set -e
echo "Disposable container removed."
exit "$status"
